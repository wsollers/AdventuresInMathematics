"""Navigation taxonomy is independent of stable card IDs and unlock dependencies."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parent
def read(deck,name): return json.loads((ROOT/deck/name).read_text(encoding='utf-8'))
decks={name:read(name,'manifest.json') for name in ['ordered-fields','calculus','geometry']}
allcards=[]
for name,manifest in decks.items():
    for s in manifest['stages']: allcards+=read(name,s['file'])
subjects=[]; used=set()
def subject(id,title):
    subjects.append(dict(id=id,title=title,topics=[]))
def topic(id,title,ids=(),future=False):
    ids=list(ids)
    assert not used.intersection(ids),id
    used.update(ids)
    subjects[-1]['topics'].append(dict(id=id,title=title,card_ids=ids,future=future))
def match(prefix): return [c['id'] for c in allcards if c['id'].startswith(prefix)]
def stage(n): return [c['id'] for c in allcards if c['id'].startswith('aim.orderedfields.') and c['stage']==n]
def calc(slug): return match('aim.calculus.'+slug+'.')
subject('logic','Logic and mathematical language');topic('logic-language','Statements, notation and proof language',stage(0))
for sid,title in [('geometry','Euclidean Geometry'),('analytic','Analytic Geometry'),('vectors','Vectors')]:
    subject(sid,title)
    for s in decks['geometry']['stages']:
        if s['subject']==sid: topic('geometry-'+s['file'][:-5],s['title'],s['card_ids'])
    if sid=='analytic': topic('coordinate-conversions','Polar, cylindrical and spherical coordinates',calc('coordinates'))
for sid,title,keys in [('sets','Sets',['set','member','predicate']),('relations','Relations',['relation','reflexive','antisymmetric','transitive','total','antisymsym']),('functions','Functions',['function','operation','closed'])]:
    subject(sid,title);topic(sid+'-basics',title+' foundations',['aim.orderedfields.01.'+k for k in keys])
subject('algebra','Algebra and ordered fields')
for s in decks['ordered-fields']['stages'][2:]: topic('foundations-'+str(s['stage']),s['title'],stage(s['stage']))
topic('algebra-calculus','Algebra for calculus',[c for c in calc('algebra') if '.geometric-' not in c])
subject('trigonometry','Trigonometry')
for slug,title in [('angles','Degrees and radians'),('trig-definitions','Definitions and exact values'),('trig-identities','Trigonometric identities')]: topic(slug,title,calc(slug))
inverse=['asin-range','acos-range','atan-range','inverse-reciprocal']
topic('inverse-trig','Inverse trigonometric definitions',['aim.calculus.trig-calculus.'+k for k in inverse])
subject('exponential','Exponential and hyperbolic functions')
topic('exp-log','Exponential and logarithmic definitions and identities',calc('exp-log'))
topic('hyperbolic','Hyperbolic definitions and identities',calc('hyperbolic'))
topic('inverse-hyperbolic','Inverse hyperbolic definitions',['aim.calculus.hyperbolic-calculus.'+k for k in ['asinh','acosh','atanh']])
subject('limits','Limits and continuity')
topic('standard-limits','Standard limits and asymptotic equivalents',[c for c in calc('limits-series') if '.series-' not in c and not c.endswith('.limit-e')])
topic('limit-rules','Limit computation rules',future=True)
topic('limit-theory','Limit definitions and theorems',future=True)
topic('continuity-theory','Continuity definitions and theorems',future=True)
subject('derivatives','Derivatives')
topic('derivative-rules','Differentiation rules',['aim.calculus.calculus-rules.'+k for k in ['product','quotient','chain','power']]+['aim.calculus.exp-log-calculus.'+k for k in ['chain-exp','chain-ln','variable-power']])
topic('standard-derivatives','Standard derivatives',[c['id'] for c in allcards if c['id'].startswith('aim.calculus.') and c['id'].split('.')[-1].startswith('d-')])
topic('derivative-definitions','Derivative definitions',future=True)
topic('derivative-theorems','Derivative theorems',future=True)
subject('integrals','Integrals')
topic('integration-rules','Integration rules and techniques',['aim.calculus.calculus-rules.'+k for k in ['power-integral','parts','substitution']]+[c['id'] for c in allcards if c['id'].startswith('aim.calculus.') and c['id'].split('.')[-1].startswith('sub-')])
topic('standard-integrals','Standard integrals',[c['id'] for c in allcards if c['id'].startswith('aim.calculus.') and c['id'].split('.')[-1].startswith('i-')])
topic('definite-integrals','Definite integral rules',['aim.calculus.calculus-rules.'+k for k in ['odd','even','reflection','ftc','variable-bounds']])
topic('integral-definitions','Integral definitions',future=True)
topic('integral-theorems','Integral theorems',future=True)
subject('series','Sequences and series')
topic('geometric-series','Geometric sums and series',[c for c in calc('algebra') if '.geometric-' in c])
topic('series-formulas','Taylor series and sequence limits',[c for c in calc('limits-series') if '.series-' in c or c.endswith('.limit-e')])
subject('complex','Complex exponentials');topic('euler','Euler’s formula',calc('complex-exponentials'))
assert used=={c['id'] for c in allcards},'Unassigned cards: '+str({c['id'] for c in allcards}-used)
(ROOT/'curriculum.json').write_text(json.dumps(dict(version=1,subjects=subjects),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(f'Curriculum: {len(subjects)} subjects; {sum(len(s["topics"]) for s in subjects)} topics; {len(used)} cards.')
