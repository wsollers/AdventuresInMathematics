// Fixed, project-owned SVG illustrations; never interpolate card content into markup.
const circle='<circle cx="150" cy="110" r="80" fill="none" stroke="currentColor" stroke-width="2"/><circle cx="150" cy="110" r="3" fill="currentColor"/><text x="135" y="132">O</text>';
const figures={
  radius:{caption:'Circle with center O and radius OP.',svg:circle+'<path d="M150 110H230"/><text x="237" y="114">P</text>'},
  diameter:{caption:'Diameter AB passes through the center O.',svg:circle+'<path d="M70 110H230"/><text x="50" y="114">A</text><text x="237" y="114">B</text>'},
  chord:{caption:'Chord AB joins two points of the circle.',svg:circle+'<path d="M86 62H214"/><text x="65" y="58">A</text><text x="220" y="58">B</text>'},
  secant:{caption:'A secant line meets the circle at A and B.',svg:circle+'<path d="M20 62H290"/><text x="76" y="50">A</text><text x="210" y="50">B</text>'},
  tangent:{caption:'Tangent at T, perpendicular to radius OT.',svg:circle+'<path d="M230 10V210M150 110H230"/><path d="M218 110V98H230" class="right-angle"/><text x="240" y="114">T</text>'}
};
export function renderDiagram(container,card) {
  container.replaceChildren();container.hidden=true;
  const prefix='aim.geometry.circles.';
  if(!card?.id.startsWith(prefix))return;
  const figure=figures[card.id.slice(prefix.length)];if(!figure)return;
  const svg=container.ownerDocument.createElement('div');
  svg.innerHTML='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 310 220" role="img"><title>'+figure.caption+'</title>'+figure.svg+'</svg>';
  const caption=container.ownerDocument.createElement('figcaption');caption.textContent=figure.caption;
  container.append(svg,caption);container.hidden=false;
}
