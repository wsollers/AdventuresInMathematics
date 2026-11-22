// Navigation never changes card IDs, prerequisites or review records.
export function indexCurriculum(curriculum, cards) {
  const byId = new Map(cards.map(c => [c.id,c]));
  const selections = new Map(), cardTopics = new Map(), keys = new Set();
  for (const subject of curriculum.subjects) {
    if (keys.has(subject.id)) throw new Error('Duplicate curriculum subject');
    keys.add(subject.id);
    const subjectCards = [];
    for (const topic of subject.topics) {
      if (selections.has('topic:'+topic.id)) throw new Error('Duplicate curriculum topic');
      if (topic.future && topic.card_ids.length) throw new Error('Future topic must be empty');
      for (const id of topic.card_ids) {
        if (!byId.has(id) || cardTopics.has(id)) throw new Error('Invalid curriculum card assignment: '+id);
        cardTopics.set(id,{subject,topic});
      }
      selections.set('topic:'+topic.id,new Set(topic.card_ids));
      subjectCards.push(...topic.card_ids);
    }
    selections.set('subject:'+subject.id,new Set(subjectCards));
  }
  if (cardTopics.size !== cards.length) throw new Error('Curriculum is missing cards');
  return {selections,cardTopics,byId};
}

export function buildCurriculum(root, select, curriculum, index, {onSelect,onCard,math}) {
  root.replaceChildren();
  const statuses=[], cardButtons=new Map();
  let currentAvailable=new Set();
  const doc=root.ownerDocument;
  const element=(tag,cls,text)=>{const e=doc.createElement(tag);if(cls)e.className=cls;if(text)e.textContent=text;return e;};
  for(const subject of curriculum.subjects) {
    const group=element('optgroup');group.label=subject.title;
    const all=element('option',null,'All '+subject.title);all.value='subject:'+subject.id;group.append(all);
    const subjectBox=element('details','curriculum-subject');subjectBox.dataset.subject=subject.id;
    const summary=element('summary',null,subject.title);
    const total=index.selections.get('subject:'+subject.id).size;
    summary.append(element('span','curriculum-count',' '+total));
    subjectBox.append(summary);
    const studySubject=element('button','topic-study','Study subject');studySubject.type='button';
    studySubject.setAttribute('aria-label','Study '+subject.title);
    studySubject.addEventListener('click',()=>onSelect('subject:'+subject.id));subjectBox.append(studySubject);
    for(const topic of subject.topics) {
      const option=element('option',null,topic.title+(topic.card_ids.length?'':' — No cards yet'));
      option.value='topic:'+topic.id;group.append(option);
      const topicBox=element('details','curriculum-topic');topicBox.dataset.topic=topic.id;
      const topicSummary=element('summary',null,topic.title);
      const status=element('span','topic-status');topicSummary.append(status);
      statuses.push({topic,status});topicBox.append(topicSummary);
      if(!topic.card_ids.length) topicBox.append(element('p','empty-topic','No cards yet. This topic is reserved for future material.'));
      else {
        const study=element('button','topic-study','Study topic');study.type='button';
        study.setAttribute('aria-label','Study '+topic.title);
        study.addEventListener('click',()=>onSelect('topic:'+topic.id));topicBox.append(study);
        const list=element('ul','curriculum-cards');topicBox.append(list);
        let populated=false;
        topicBox.addEventListener('toggle',()=>{
          if(!topicBox.open || populated)return;populated=true;
          for(const id of topic.card_ids) {
            const card=index.byId.get(id), li=element('li'), button=element('button','card-link');
            button.type='button';button.dataset.cardId=id;
            const question=element('span','card-question');math(question,card.front);
            const badge=element('span','card-lock',currentAvailable.has(id)?'Browse card':'Locked for review · browse card');
            button.append(question,badge);button.addEventListener('click',()=>onCard(card,'topic:'+topic.id));
            cardButtons.set(id,{button,badge});li.append(button);list.append(li);
          }
        });
      }
      subjectBox.append(topicBox);
    }
    select.append(group);root.append(subjectBox);
  }
  return {refresh(available,currentId) {
    currentAvailable=available;
    for(const {topic,status} of statuses) {
      const n=topic.card_ids.filter(id=>available.has(id)).length;
      status.textContent=topic.card_ids.length ? `${topic.card_ids.length} cards · ${n} available` : 'No cards yet';
    }
    for(const [id,{button,badge}] of cardButtons) {
      badge.textContent=available.has(id)?'Browse card':'Locked for review · browse card';
      if(id===currentId)button.setAttribute('aria-current','true');else button.removeAttribute('aria-current');
    }
  }};
}
