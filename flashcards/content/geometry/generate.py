"""Atomic Euclidean geometry, analytic geometry and computational vector cards."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parent
groups=[]
def group(subject,slug,title):
    groups.append(dict(subject=subject,slug=slug,title=title,stage=30+len(groups),cards=[]))
def rows(text,kind='theorem',note=''):
    g=groups[-1]
    for line in text.strip().splitlines():
        key,front,back=line.split(' | ')
        card_type='definition' if front.startswith('Define ') else 'example' if key.endswith('example') or key in ['evaluate','domain'] else kind
        g['cards'].append(dict(id=f"aim.geometry.{g['slug']}.{key}",stage=g['stage'],topic=g['title'],subject=g['subject'],type=card_type,difficulty='foundation',front=front,back=back,explanation=note or 'Assume ordinary Euclidean geometry; lengths and radii are nonnegative. Include the stated hypotheses when recalling the result.',source={'note':'Elementary reference card; not a claim of formal Lean verification.'},prerequisites=[],tags=[g['subject'],g['slug']]))

group('geometry','foundations','Points, lines and angles')
rows(r'''
point | What does a point represent in elementary geometry? | An exact position, with no length, area or volume. Point is a primitive notion in an axiomatic treatment.
line | What is a Euclidean line? | A straight one-dimensional object extending indefinitely in both directions. Line is a primitive notion in an axiomatic treatment.
plane | What is a Euclidean plane? | A flat two-dimensional object extending indefinitely. Plane is a primitive notion in an axiomatic treatment.
segment | Define the segment $\overline{AB}$. | The points on the line through distinct $A,B$ lying between $A$ and $B$, including the endpoints.
ray | Define a ray from $A$ through $B\ne A$. | The part of their line beginning at $A$ and extending indefinitely in the direction of $B$.
angle | Define an angle and its vertex. | Two rays with a common endpoint form an angle; their common endpoint is the vertex.
collinear | Define collinear points. | Points lying on one line.
coplanar | Define coplanar objects. | Objects contained in one plane.
parallel | Define distinct parallel lines in Euclidean space. | Distinct coplanar lines that never intersect.
skew | Define skew lines. | Noncoplanar lines in three-dimensional space; they neither intersect nor are parallel.
perpendicular | Define perpendicular lines. | Intersecting lines forming a right angle.
right | Measure of a right angle? | $90^\circ$.
straight | Measure of a straight angle? | $180^\circ$.
acute | Define an acute angle. | An angle of measure strictly between $0^\circ$ and $90^\circ$.
obtuse | Define an obtuse angle. | An angle of measure strictly between $90^\circ$ and $180^\circ$.
complementary | Define complementary angles. | Two angles whose measures sum to $90^\circ$.
supplementary | Define supplementary angles. | Two angles whose measures sum to $180^\circ$.
bisector | Define an angle bisector. | A ray from the vertex dividing an angle into two equal angles.
midpoint | Define the midpoint of a segment. | The point on the segment equidistant from its two endpoints.
perp-bisector | Define the perpendicular bisector of a segment in a plane. | The line through its midpoint perpendicular to the segment.
''','definition')
group('geometry','line-angles','Parallel lines and angle theorems')
rows(r'''
vertical-def | Define vertical angles. | Opposite angles formed by two intersecting lines.
vertical | Relation between vertical angles? | Vertical angles have equal measures.
linear | If adjacent angles have noncommon sides that are opposite rays, what is their sum? | $180^\circ$; they form a linear pair.
transversal | Define a transversal. | A line intersecting two or more coplanar lines at distinct points.
corresponding | A transversal crosses parallel lines. How do corresponding angles compare? | Corresponding angles are equal; they occupy matching positions at the two intersections.
alternate | A transversal crosses parallel lines. How do alternate interior angles compare? | Alternate interior angles are equal; they lie between the lines on opposite sides of the transversal.
same-side | A transversal crosses parallel lines. What is the sum of same-side interior angles? | $180^\circ$.
converse-corresponding | If corresponding angles made by a transversal of two coplanar lines are equal, what follows? | The two lines are parallel.
converse-alternate | If alternate interior angles made by a transversal of two coplanar lines are equal, what follows? | The two lines are parallel.
converse-same-side | If same-side interior angles made by a transversal of two coplanar lines sum to $180^\circ$, what follows? | The two lines are parallel.
parallel-axiom | Through a point not on a given line, how many coplanar parallels to that line exist? | Exactly one, in Euclidean geometry.
bisector-locus | What is the locus in a plane of points equidistant from two distinct points $A,B$? | The perpendicular bisector of $\overline{AB}$.
''')
group('geometry','triangles','Triangles and their theorems')
rows(r'''
triangle | Define a triangle. | Three noncollinear points together with the three segments joining them.
equilateral | Define an equilateral triangle. | A triangle with three equal side lengths.
isosceles | Define an isosceles triangle. | A triangle with at least two equal side lengths; this convention includes equilateral triangles.
scalene | Define a scalene triangle. | A triangle with three different side lengths.
right | Define a right triangle. | A triangle with one right angle; its opposite side is the hypotenuse.
acute | Define an acute triangle. | A triangle with all three angles acute.
obtuse | Define an obtuse triangle. | A triangle with one obtuse angle.
altitude | Define an altitude of a triangle. | A perpendicular segment from a vertex to the line containing the opposite side.
median | Define a median of a triangle. | A segment from a vertex to the midpoint of the opposite side.
sum | Sum of the interior angles of a Euclidean triangle? | $A+B+C=180^\circ$.
exterior | An exterior angle is formed by extending one side of a triangle. What is its measure? | The sum of the two nonadjacent interior angles.
inequality | What length condition characterizes a nondegenerate triangle with positive sides $a,b,c$? | Each side is shorter than the sum of the other two.
base | What follows from two sides of a triangle being equal? | The angles opposite those sides are equal.
base-converse | What follows from two angles of a triangle being equal? | The sides opposite those angles are equal.
pythagoras | In a right triangle with legs $a,b$ and hypotenuse $c$, relate the side lengths. | $a^2+b^2=c^2$.
pythagoras-converse | A triangle has longest side $c$ and $a^2+b^2=c^2$. What follows? | The angle opposite $c$ is a right angle.
midsegment | What does the triangle midsegment theorem say? | The segment joining the midpoints of two sides is parallel to the third side and half its length.
centroid | In what ratio does the centroid divide each median? | $2:1$, measured from the vertex toward the midpoint of the opposite side.
angle-bisector | In triangle $ABC$, the internal angle bisector from $A$ meets $BC$ at $D$. Relate the lengths. | $BD/DC=AB/AC$.
''')
group('geometry','congruence','Congruence and similarity')
rows(r'''
congruent | Define congruent figures. | Figures that can be matched exactly by a distance-preserving motion; corresponding lengths and angles agree.
similar | Define similar figures. | Figures related by a uniform scaling and a distance-preserving motion; corresponding angles agree and lengths share one positive scale factor.
sss | State the SSS triangle congruence criterion. | Three pairs of corresponding side lengths are equal.
sas | State the SAS triangle congruence criterion. | Two pairs of corresponding side lengths and their included angles are equal.
asa | State the ASA triangle congruence criterion. | Two pairs of corresponding angles and the included sides are equal.
aas | State the AAS triangle congruence criterion. | Two pairs of corresponding angles and a corresponding nonincluded side are equal.
hl | State the hypotenuse–leg congruence criterion. | Two right triangles are congruent if their hypotenuses and one pair of corresponding legs are equal.
aaa | Does AAA establish triangle congruence? | No. It establishes similarity; the scale may differ.
ssa | Does general SSA establish triangle congruence? | No. Two sides and a nonincluded angle can leave two possible triangles.
aa-similarity | State the AA triangle similarity criterion. | Two pairs of corresponding angles are equal.
sss-similarity | State the SSS triangle similarity criterion. | All three pairs of corresponding sides are in the same positive ratio.
sas-similarity | State the SAS triangle similarity criterion. | Two pairs of corresponding sides are proportional and their included angles are equal.
perimeter | Similar figures have length scale factor $k>0$. How do perimeters scale? | $P_{\mathrm{new}}=kP_{\mathrm{old}}$.
area | Similar plane figures have length scale factor $k>0$. How do areas scale? | $A_{\mathrm{new}}=k^2A_{\mathrm{old}}$.
volume | Similar solids have length scale factor $k>0$. How do volumes scale? | $V_{\mathrm{new}}=k^3V_{\mathrm{old}}$.
''')
group('geometry','measurement','Polygons, areas and measurement')
rows(r'''
polygon | Define a simple polygon. | A closed chain of straight segments in a plane whose edges meet only at adjacent endpoints.
regular | Define a regular polygon. | A convex polygon with all sides equal and all interior angles equal.
parallelogram | Define a parallelogram. | A quadrilateral with both pairs of opposite sides parallel.
rectangle | Define a rectangle. | A quadrilateral with four right angles.
rhombus | Define a rhombus. | A quadrilateral with four equal side lengths.
square | Define a square. | A quadrilateral with four equal sides and four right angles.
trapezoid | Define a trapezoid using the inclusive convention. | A quadrilateral with at least one pair of parallel sides. Some texts use exactly one pair.
interior | Interior-angle sum of a simple Euclidean $n$-gon? | $(n-2)180^\circ$, where $n\geq3$.
regular-angle | Each interior angle of a regular $n$-gon? | $(n-2)180^\circ/n$.
exterior | Sum of one exterior turning angle at each vertex of a convex polygon, traversed in one direction? | $360^\circ$.
triangle-area | Triangle area with base $b$ and perpendicular height $h$? | $A=bh/2$.
rectangle-area | Rectangle area with length $l$ and width $w$? | $A=lw$.
square-area | Square area with side length $s$? | $A=s^2$.
parallelogram-area | Parallelogram area with base $b$ and perpendicular height $h$? | $A=bh$.
trapezoid-area | Trapezoid area with parallel bases $a,b$ and perpendicular height $h$? | $A=(a+b)h/2$.
rhombus-area | Rhombus area in terms of diagonal lengths $d_1,d_2$? | $A=d_1d_2/2$.
regular-area | Regular polygon area with perimeter $P$ and apothem $a$? | $A=Pa/2$; the apothem is the distance from the center to a side.
circle-area | Circle area with radius $r$? | $A=\pi r^2$.
circumference | Circle circumference with radius $r$? | $C=2\pi r$.
arc | Arc length for radius $r$ and nonnegative central angle $\theta$ in radians? | $s=r\theta$.
sector | Sector area for radius $r$ and central angle $0\leq\theta\leq2\pi$ in radians? | $A=r^2\theta/2$.
box-volume | Rectangular box volume with edge lengths $l,w,h$? | $V=lwh$.
cylinder-volume | Circular cylinder volume with radius $r$ and height $h$? | $V=\pi r^2h$.
cone-volume | Circular cone volume with radius $r$ and perpendicular height $h$? | $V=\pi r^2h/3$.
sphere-volume | Sphere volume with radius $r$? | $V=4\pi r^3/3$.
sphere-area | Sphere surface area with radius $r$? | $A=4\pi r^2$.
''')
group('geometry','circles','Circle definitions and theorems')
rows(r'''
circle | Define a circle in a Euclidean plane. | The set of points at a fixed positive distance from a fixed center.
disk | How does a disk differ from a circle? | The closed disk includes the interior as well as its boundary circle.
radius | Define a radius of a circle. | A segment from the center to a point on the circle; its length is also called the radius.
diameter | Define a diameter of a circle. | A chord through the center; its length is twice the radius.
chord | Define a chord. | A segment joining two distinct points of a circle.
secant | Define a secant line to a circle. | A line intersecting the circle at two distinct points.
tangent | Define a tangent line to a circle. | A coplanar line intersecting the circle at exactly one point, the point of tangency.
arc | Define a circular arc. | A connected portion of a circle between two endpoints.
central-angle | Define a central angle. | An angle with vertex at the circle’s center and sides passing through the circle.
inscribed-angle | Define an inscribed angle. | An angle with vertex on the circle and sides containing chords.
intercepted-arc | Which arc is intercepted by an inscribed angle? | The arc between the other endpoints of its chords that does not contain the angle’s vertex.
inscribed | Relate an inscribed angle to its intercepted arc, both measured in degrees. | The angle’s measure is half the arc’s measure.
semicircle | What angle does a diameter subtend at another point of its circle? | A right angle.
cyclic | Relation between opposite interior angles of a convex cyclic quadrilateral? | They are supplementary.
radius-tangent | How does the tangent at $T$ relate to radius $OT$? | The tangent is perpendicular to $OT$.
tangent-converse | A line through circle point $T$ is perpendicular to radius $OT$. What follows? | The line is tangent to the circle at $T$.
equal-tangents | From an exterior point $P$, tangents touch a circle at $A,B$. Relate the lengths. | $PA=PB$.
equal-chords | In the same circle, what follows from two chords having equal lengths? | Their minor arcs have equal measures.
chord-distance | In the same circle, how do equal chords relate to the center? | They are equidistant from the center, using perpendicular distance to their lines.
chord-bisector | A line through the center is perpendicular to a chord. What does it do to the chord? | It bisects the chord.
intersecting | Chords $AB$ and $CD$ meet at an interior point $P$. State the product theorem. | $PA\cdot PB=PC\cdot PD$.
secant-product | Two secants from exterior point $P$ meet a circle at near/far points $A,B$ and $C,D$. State the product theorem. | $PA\cdot PB=PC\cdot PD$; use external segment times whole secant.
tangent-secant | A tangent from $P$ touches at $T$; a secant meets the circle at near/far points $A,B$. Relate the lengths. | $PT^2=PA\cdot PB$.
tangent-chord | What is the measure of an angle formed by a tangent and a chord at the point of tangency? | Half the measure of the arc intercepted by that angle; choose the arc corresponding to the chosen tangent ray.
inside-angle | Two chords cross inside a circle. How is an angle’s measure related to the intercepted arcs? | Half the sum of the measures of the arcs intercepted by that angle and its vertical angle.
outside-angle | Two secants from an exterior point form an angle. How is its measure related to the intercepted arcs? | Half the difference between the far arc’s measure and the near arc’s measure.
''')

group('analytic','cartesian','Cartesian coordinates and distance')
rows(r'''
coordinates | What does $(x,y)$ specify in a Cartesian plane? | Signed distances along two perpendicular coordinate axes from the origin, using a common unit scale.
origin | Coordinates of the origin in three dimensions? | $(0,0,0)$.
quadrants | Signs of $(x,y)$ in quadrants I, II, III and IV? | I: $(+,+)$; II: $(-,+)$; III: $(-,-)$; IV: $(+,-)$.
octants | What are the octants of Cartesian 3D space? | The eight regions determined by the signs of the three nonzero coordinates. Numbering conventions vary.
xy-plane | Equation of the $xy$-coordinate plane? | $z=0$.
xz-plane | Equation of the $xz$-coordinate plane? | $y=0$.
yz-plane | Equation of the $yz$-coordinate plane? | $x=0$.
distance2 | Distance between $(x_1,y_1)$ and $(x_2,y_2)$? | $d=\sqrt{(x_2-x_1)^2+(y_2-y_1)^2}$.
distance3 | Distance between points $P,Q$ in Cartesian 3D space? | $d=\sqrt{(Q_x-P_x)^2+(Q_y-P_y)^2+(Q_z-P_z)^2}$.
midpoint | Midpoint of position vectors $P,Q$? | $M=(P+Q)/2$, componentwise.
division | Point $R$ internally divides $PQ$ with $PR:RQ=m:n$, $m,n>0$. Find $R$. | $R=(nP+mQ)/(m+n)$.
''')
group('analytic','lines','Equations and relationships of lines')
rows(r'''
slope | Slope through $(x_1,y_1)$ and $(x_2,y_2)$, with $x_2\ne x_1$? | $m=(y_2-y_1)/(x_2-x_1)$.
point-slope | Equation of a line of slope $m$ through $(x_0,y_0)$? | $y-y_0=m(x-x_0)$.
intercept | Slope–intercept equation of a nonvertical line? | $y=mx+b$, where $b$ is the $y$-intercept.
general | General Cartesian equation of a line in a plane? | $Ax+By+C=0$, with $(A,B)\ne(0,0)$.
vertical | Equation of a vertical line through $(x_0,y_0)$? | $x=x_0$; its slope is undefined.
parametric | Vector equation of the line through $P$ with nonzero direction $u$? | $X=P+tu$, for $t\in\mathbb R$.
two-points | Parametric equation of the line through distinct points $P,Q$? | $X=P+t(Q-P)$, for $t\in\mathbb R$.
symmetric | Symmetric equation of a 3D line through $(x_0,y_0,z_0)$ with all direction components nonzero? | $\dfrac{x-x_0}{u_x}=\dfrac{y-y_0}{u_y}=\dfrac{z-z_0}{u_z}$.
zero-component | How do you write a line equation if its direction has $u_x=0$? | Write $x=x_0$ separately; do not divide by $u_x$. Parametric form always works.
parallel | Test parallel directions $u,v\ne0$. | $u=\lambda v$ for some nonzero scalar $\lambda$. Lines may then be coincident or distinct parallel lines.
perpendicular | Test perpendicular directions $u,v\ne0$. | $u\cdot v=0$. For perpendicular lines, also require intersection.
slopes-perp | Perpendicularity test for two lines with finite slopes $m_1,m_2$? | $m_1m_2=-1$. A vertical line is perpendicular to a horizontal line.
angle | Acute or right angle between unoriented lines with directions $u,v\ne0$? | $\theta=\arccos\!\left(\dfrac{|u\cdot v|}{\|u\|\|v\|}\right)$.
intersection | How do you find an intersection of $P+tu$ and $Q+sv$? | Solve $P+tu=Q+sv$ simultaneously in all coordinates for $t,s$. In 3D a solution need not exist.
''')
group('analytic','planes','Planes, normals and intersections')
rows(r'''
normal | Define a normal vector to a plane. | A nonzero vector perpendicular to every direction lying in that plane.
point-normal | Equation of a plane through $P$ with normal $n\ne0$? | $n\cdot(X-P)=0$.
cartesian | General Cartesian equation of a plane? | $Ax+By+Cz+D=0$, with $(A,B,C)\ne(0,0,0)$.
coefficients | A plane is $Ax+By+Cz+D=0$. Give a normal vector. | $n=(A,B,C)$.
parametric | Parametric equation of a plane through $P$ with nonparallel directions $u,v$? | $X=P+su+tv$, for $s,t\in\mathbb R$.
three-points | Find a normal to the plane through noncollinear points $P,Q,R$. | $n=(Q-P)\times(R-P)$.
parallel | Test whether two planes have parallel directions. | Their nonzero normals are scalar multiples. The planes may coincide or be distinct parallel planes.
perpendicular | Test whether two planes are perpendicular. | $n_1\cdot n_2=0$, for nonzero normals.
angle | Acute or right angle between two planes with normals $n_1,n_2$? | $\theta=\arccos\!\left(\dfrac{|n_1\cdot n_2|}{\|n_1\|\|n_2\|}\right)$.
line-parallel | Test whether direction $u$ of a line is parallel to a plane of normal $n$. | $u\cdot n=0$; the line is either contained in the plane or disjoint from it.
line-normal | Test whether a line is perpendicular to a plane. | Its nonzero direction is a scalar multiple of the plane’s normal.
line-angle | Acute or right angle between a line of direction $u$ and a plane of normal $n$? | $\alpha=\arcsin\!\left(\dfrac{|u\cdot n|}{\|u\|\|n\|}\right)$.
line-intersection | Find the parameter where $X=P+tu$ meets $n\cdot X+d=0$, assuming $n\cdot u\ne0$. | $t=-(n\cdot P+d)/(n\cdot u)$.
planes-intersection | Direction of the intersection line of two nonparallel planes? | $u=n_1\times n_2$.
perp-line | Equation of the line through $P$ perpendicular to a plane of normal $n$? | $X=P+tn$, for $t\in\mathbb R$.
''')
group('analytic','closest','Distances and closest points')
rows(r'''
point-line2 | Distance from $(x_0,y_0)$ to $Ax+By+C=0$? | $d=|Ax_0+By_0+C|/\sqrt{A^2+B^2}$, with $(A,B)\ne(0,0)$.
point-plane | Distance from point $P$ to plane $n\cdot X+d=0$? | $\delta=|n\cdot P+d|/\|n\|$, with $n\ne0$.
foot-plane | Closest point on $n\cdot X+d=0$ to $P$? | $H=P-\dfrac{n\cdot P+d}{\|n\|^2}n$.
foot-line | Closest point on line $A+tu$, $u\ne0$, to point $P$? | $H=A+\dfrac{(P-A)\cdot u}{u\cdot u}u$.
point-line3 | Distance from point $P$ to line $A+tu$ in 3D? | $\delta=\|(P-A)\times u\|/\|u\|$, with $u\ne0$.
parallel-lines | Distance between parallel lines $A+tu$ and $B+su$ in 3D? | $\delta=\|(B-A)\times u\|/\|u\|$, with $u\ne0$.
skew-lines | Distance between 3D lines $A+tu$ and $B+sv$ with nonparallel directions? | $\delta=\dfrac{|(B-A)\cdot(u\times v)|}{\|u\times v\|}$. It is zero if they intersect.
parallel-planes | Distance between parallel planes $n\cdot X+d_1=0$ and $n\cdot X+d_2=0$, written with the same normal? | $\delta=|d_2-d_1|/\|n\|$, with $n\ne0$.
line-plane | Distance between a line $P+tu$ parallel to plane $n\cdot X+d=0$? | $\delta=|n\cdot P+d|/\|n\|$. It is zero if the line lies in the plane.
intersecting-distance | Distance between an infinite line and a plane it intersects? | Zero. Likewise, two intersecting planes have distance zero.
segment | Closest point on segment from $A$ to $B\ne A$ to point $P$? | $H=A+t(B-A)$, where $t$ is $(P-A)\cdot(B-A)/\|B-A\|^2$ clamped to $[0,1]$.
''')
group('analytic','conics','Conics and standard surfaces')
rows(r'''
circle | Equation of a circle centered at $(h,k)$ with radius $r>0$? | $(x-h)^2+(y-k)^2=r^2$.
ellipse | Standard axis-aligned ellipse centered at the origin? | $x^2/a^2+y^2/b^2=1$, with $a,b>0$.
parabola | Equation of a parabola with vertex at the origin, focus $(0,p)$ and directrix $y=-p$, $p\ne0$? | $x^2=4py$.
parabola-definition | Define a parabola by distance. | The locus of points equidistant from a focus and a directrix line not containing that focus.
hyperbola | Standard hyperbola opening along the $x$-axis? | $x^2/a^2-y^2/b^2=1$, with $a,b>0$.
hyperbola-asymptotes | Asymptotes of $x^2/a^2-y^2/b^2=1$? | $y=\pm(b/a)x$.
sphere | Equation of a sphere centered at $(h,k,l)$ with radius $R>0$? | $(x-h)^2+(y-k)^2+(z-l)^2=R^2$.
cylinder | Equation of a circular cylinder of radius $R>0$ about the $z$-axis? | $x^2+y^2=R^2$, with $z$ unrestricted.
cone | Equation of a circular double cone about the $z$-axis? | $x^2+y^2=k^2z^2$, with $k>0$.
ellipsoid | Standard ellipsoid centered at the origin? | $x^2/a^2+y^2/b^2+z^2/c^2=1$, with $a,b,c>0$.
elliptic-paraboloid | Standard elliptic paraboloid opening upward? | $z=x^2/a^2+y^2/b^2$, with $a,b>0$.
hyperbolic-paraboloid | Standard hyperbolic paraboloid (saddle)? | $z=x^2/a^2-y^2/b^2$, with $a,b>0$.
one-sheet | Standard hyperboloid of one sheet with axis along $z$? | $x^2/a^2+y^2/b^2-z^2/c^2=1$, with $a,b,c>0$.
two-sheets | Standard hyperboloid of two sheets with axis along $z$? | $z^2/c^2-x^2/a^2-y^2/b^2=1$, with $a,b,c>0$.
implicit | General implicit representation of a surface? | $F(x,y,z)=0$. Such a zero set need not be a smooth surface everywhere.
graph | Represent a surface as the graph of a scalar function of two variables. | $z=f(x,y)$, for $(x,y)$ in the function’s domain. Not every whole surface is one such graph.
parametric | General parametric representation of a surface? | $X=r(u,v)$, a vector-valued function of two parameters. Degenerate parameterizations are possible.
translate | How do you translate an equation centered at the origin to center $(h,k,l)$? | Replace $x,y,z$ by $x-h,y-k,z-l$, respectively.
intercepts | How do you find a surface’s $x$-axis intercepts? | Set $y=z=0$ and solve for $x$.
sphere-normal | Normal direction to a sphere centered at $C$, at a point $P$ on it? | $n=P-C$.
sphere-tangent | Tangent plane to a sphere centered at $C$, at a point $P$ on it? | $(P-C)\cdot(X-P)=0$, for a sphere of positive radius.
''')

group('vectors','components','Vector components and operations')
rows(r'''
vector | What information does a geometric vector describe? | Magnitude and direction; a free vector can be translated without changing it.
position | Position vector of point $P=(x,y,z)$ relative to the origin? | $\overrightarrow{OP}=(x,y,z)$.
displacement | Displacement from point $P$ to point $Q$? | $\overrightarrow{PQ}=Q-P$.
add | Add $u=(u_1,u_2,u_3)$ and $v=(v_1,v_2,v_3)$. | $u+v=(u_1+v_1,u_2+v_2,u_3+v_3)$.
subtract | Subtract $v$ from $u$ componentwise. | $u-v=(u_1-v_1,u_2-v_2,u_3-v_3)$.
scale | Multiply $u=(u_1,u_2,u_3)$ by scalar $c$. | $cu=(cu_1,cu_2,cu_3)$.
magnitude | Magnitude of $u=(u_1,u_2,u_3)$? | $\|u\|=\sqrt{u_1^2+u_2^2+u_3^2}$.
unit | Unit vector in the direction of $u\ne0$? | $\widehat u=u/\|u\|$.
length-direction | Vector of prescribed length $L>0$ in the direction of $u\ne0$? | $v=L u/\|u\|$.
zero | Does the zero vector have a direction or a unit normalization? | No; its magnitude is zero and division by its magnitude is undefined.
i | Standard unit vector in the positive $x$-direction? | $\mathbf i=(1,0,0)$.
j | Standard unit vector in the positive $y$-direction? | $\mathbf j=(0,1,0)$.
k | Standard unit vector in the positive $z$-direction? | $\mathbf k=(0,0,1)$.
polar | Components of a planar vector of magnitude $L$ at angle $\theta$ from the positive $x$-axis? | $v=(L\cos\theta,L\sin\theta)$.
''','definition')
group('vectors','dot-projection','Dot products and projection')
rows(r'''
dot | Component formula for $u\cdot v$ in 3D? | $u\cdot v=u_1v_1+u_2v_2+u_3v_3$.
angle | Angle between nonzero vectors $u,v$? | $\theta=\arccos\!\left(\dfrac{u\cdot v}{\|u\|\|v\|}\right)$, in $[0,\pi]$.
perp | Dot-product test for perpendicular nonzero vectors? | $u\cdot v=0$.
scalar | Signed scalar component of $u$ in the direction of $v\ne0$? | $\operatorname{comp}_v u=(u\cdot v)/\|v\|$.
projection | Vector projection of $u$ onto $v\ne0$? | $\operatorname{proj}_v u=\dfrac{u\cdot v}{v\cdot v}v$.
perpendicular | Component of $u$ perpendicular to $v\ne0$? | $u_\perp=u-\operatorname{proj}_v u$.
decompose | Decompose $u$ into components parallel and perpendicular to $v\ne0$. | $u=\operatorname{proj}_v u+(u-\operatorname{proj}_v u)$.
work | Work done by a constant force $F$ through displacement $d$? | $W=F\cdot d$.
example | Compute $(1,2,3)\cdot(4,-1,2)$. | $8$.
projection-example | Project $u=(3,4)$ onto $v=(1,0)$. | $\operatorname{proj}_v u=(3,0)$.
''')
group('vectors','cross-triple','Cross products and triple products')
rows(r'''
cross | Component formula for $u\times v$ in right-handed Cartesian 3D coordinates? | $u\times v=(u_2v_3-u_3v_2,\ u_3v_1-u_1v_3,\ u_1v_2-u_2v_1)$.
right-hand | Direction of $u\times v$ for nonparallel vectors? | Perpendicular to both; curl the right-hand fingers from $u$ toward $v$ through the smaller angle, and the thumb gives the direction.
magnitude | Magnitude of $u\times v$ in terms of their angle $\theta$? | $\|u\times v\|=\|u\|\|v\|\sin\theta$, where $0\leq\theta\leq\pi$.
reverse | How does reversing a cross product change it? | $v\times u=-(u\times v)$.
parallel | Cross-product test for parallel nonzero vectors in 3D? | $u\times v=0$.
area | Parallelogram area spanned by vectors $u,v$? | $A=\|u\times v\|$.
triangle | Triangle area with two edge vectors $u,v$ from a common vertex? | $A=\|u\times v\|/2$.
normal | Unit normal from two nonparallel vectors $u,v$? | $n=(u\times v)/\|u\times v\|$; its negative is the other orientation.
torque | Torque of force $F$ applied at displacement $r$ from a pivot? | $\tau=r\times F$.
scalar-triple | Define the scalar triple product of $u,v,w$. | $u\cdot(v\times w)$.
volume | Volume of the parallelepiped spanned by $u,v,w$? | $V=|u\cdot(v\times w)|$.
coplanar | Scalar-triple-product test for coplanar vectors $u,v,w$ in 3D? | $u\cdot(v\times w)=0$.
vector-triple | Expand $u\times(v\times w)$. | $u\times(v\times w)=v(u\cdot w)-w(u\cdot v)$.
example | Compute $\mathbf i\times\mathbf j$ in right-handed coordinates. | $\mathbf k$.
''')
group('vectors','vector-functions','Vector-valued computations and applications')
rows(r'''
function | What is a vector-valued function of a scalar parameter? | A rule assigning a vector to each allowed scalar input, for example $r(t)=(f(t),g(t),h(t))$.
evaluate | Evaluate $r(t)=(t,t^2,2t-1)$ at $t=2$. | $r(2)=(2,4,3)$.
domain | Domain of $r(t)=(\sqrt t,1/(t-1),\ln(t+2))$ over the reals? | $[0,1)\cup(1,\infty)$; all components must be defined.
sum | If $r(t)=(t,1)$ and $s(t)=(2,t^2)$, compute $r(t)+s(t)$. | $(t+2,1+t^2)$.
dot-function | If $r(t)=(t,1)$ and $s(t)=(2,t^2)$, compute $r(t)\cdot s(t)$. | $2t+t^2$; the output is a scalar.
cross-function | If $r(t)=(t,0,0)$ and $s(t)=(0,1,t)$, compute $r(t)\times s(t)$. | $(0,-t^2,t)$; the output is a vector.
vector-input | Example of evaluating a function with vector input: $F(x,y)=(x+y,x-y)$ at $(3,1)$? | $F(3,1)=(4,2)$.
resultant | Resultant of forces $F_1,\ldots,F_n$ expressed in the same coordinate frame? | $F_{\mathrm{net}}=\sum_{j=1}^n F_j$.
relative | Velocity of object $A$ relative to $B$, given their velocities in one frame? | $v_{A/B}=v_A-v_B$.
line-direction | Direction vector of a line through distinct points $P,Q$? | $u=Q-P$.
plane-normal | Normal vector of a plane containing nonparallel directions $u,v$? | $n=u\times v$.
''',note='Computational use only; no vector-space theory or calculus is assumed. All components use the same coordinate frame.')

def write(name,obj):
    (ROOT/name).write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
cards=[]; stages=[]; levels=[]
for g in groups:
    ids=[c['id'] for c in g['cards']]
    write(g['slug']+'.json',g['cards'])
    stages.append(dict(stage=g['stage'],subject=g['subject'],title=g['title'],file=g['slug']+'.json',card_ids=ids))
    levels.append(dict(id='geometry-'+g['slug'],title=g['title'],requires=[],card_ids=ids))
    cards.extend(g['cards'])
write('manifest.json',dict(version=1,title='Geometry and computational vectors',stages=stages,cards=[{k:c[k] for k in ['id','stage','topic','type']} for c in cards]))
write('unlock-levels.json',dict(version=1,policy='manual-unlock',default_unlocked=[l['id'] for l in levels],levels=levels))
print(f'Generated {len(cards)} cards in {len(groups)} topics.')
