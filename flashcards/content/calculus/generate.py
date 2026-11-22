"""Generate the independently reviewable calculus reference topics (no Lean claims)."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
topics = []

def topic(slug, title):
    topics.append(dict(slug=slug, title=title, stage=9+len(topics), cards=[]))

def card(key, front, back, note="", kind="theorem"):
    t = topics[-1]
    t['cards'].append(dict(id=f"aim.calculus.{t['slug']}.{key}", type=kind,
        stage=t['stage'], topic=t['title'], difficulty="foundation", front=front,
        back=back, explanation=note or "Recall this single fact, including its domain restrictions.",
        source={"note":"Calculus reference card; not a claim of formal Lean verification."},
        prerequisites=[], tags=["calculus", t['slug']]))

def rows(text, note=""):
    for line in text.strip().splitlines():
        key, front, back = line.split(" | ")
        card(key, front, back, note)

topic('angles', 'Degrees and radians')
rows(r'''
radian | Define a radian using arc length $s$ and radius $r$. | $\theta=s/r$. One radian subtends an arc equal in length to the radius.
degrees-to-radians | Convert an angle $d$ in degrees to radians. | $\theta=d\pi/180$.
radians-to-degrees | Convert an angle $\theta$ in radians to degrees. | $d=180\theta/\pi$.
arc | Arc length for angle $\theta$ in radians? | $s=r\theta$ for a nonnegative swept angle.
sector | Circular sector area for angle $\theta$ in radians? | $A=\tfrac12r^2\theta$ for a nonnegative swept angle.
''')
angles = [(0,'0'),(30,r'\pi/6'),(45,r'\pi/4'),(60,r'\pi/3'),(90,r'\pi/2'),(120,r'2\pi/3'),(135,r'3\pi/4'),(150,r'5\pi/6'),(180,r'\pi'),(210,r'7\pi/6'),(225,r'5\pi/4'),(240,r'4\pi/3'),(270,r'3\pi/2'),(300,r'5\pi/3'),(315,r'7\pi/4'),(330,r'11\pi/6'),(360,r'2\pi')]
for d, r in angles:
    card(f'deg-{d}', f'Convert ${d}^\\circ$ to radians.', f'${r}$ radians.',kind='example')
    card(f'rad-{d}', f'Convert ${r}$ radians to degrees.', f'${d}^\\circ$.',kind='example')

topic('trig-definitions', 'Trigonometric definitions and exact values')
rows(r'''
unit-circle | Coordinates of the unit-circle point at angle $\theta$? | $(\cos\theta,\sin\theta)$.
sin-triangle | Right-triangle definition of $\sin\theta$? | $\sin\theta=\text{opposite}/\text{hypotenuse}$.
cos-triangle | Right-triangle definition of $\cos\theta$? | $\cos\theta=\text{adjacent}/\text{hypotenuse}$.
tan-triangle | Right-triangle definition of $\tan\theta$? | $\tan\theta=\text{opposite}/\text{adjacent}$.
tan | Define tangent using sine and cosine. | $\tan x=\sin x/\cos x$, for $\cos x\ne0$.
cot | Define cotangent using sine and cosine. | $\cot x=\cos x/\sin x$, for $\sin x\ne0$.
sec | Define secant. | $\sec x=1/\cos x$, for $\cos x\ne0$.
csc | Define cosecant. | $\csc x=1/\sin x$, for $\sin x\ne0$.
q1 | Signs of sine, cosine and tangent in quadrant I? | All three are positive.
q2 | Signs of sine, cosine and tangent in quadrant II? | Sine is positive; cosine and tangent are negative.
q3 | Signs of sine, cosine and tangent in quadrant III? | Tangent is positive; sine and cosine are negative.
q4 | Signs of sine, cosine and tangent in quadrant IV? | Cosine is positive; sine and tangent are negative.
''')
for fn, vals in [('sin',['0',r'\tfrac12',r'\tfrac{\sqrt2}{2}',r'\tfrac{\sqrt3}{2}','1']),('cos',['1',r'\tfrac{\sqrt3}{2}',r'\tfrac{\sqrt2}{2}',r'\tfrac12','0'])]:
    for (d,r),v in zip(angles[:5], vals):
        card(f'{fn}-{d}',f'Evaluate $\\{fn}({r})$ exactly.',f'${v}$.',kind='example')

topic('trig-identities', 'Trigonometric identities')
rows(r'''
pythagorean | Fundamental Pythagorean identity? | $\sin^2x+\cos^2x=1$.
tan-pythagorean | Pythagorean identity involving tangent? | $1+\tan^2x=\sec^2x$.
cot-pythagorean | Pythagorean identity involving cotangent? | $1+\cot^2x=\csc^2x$.
sin-odd | Simplify $\sin(-x)$. | $-\sin x$.
cos-even | Simplify $\cos(-x)$. | $\cos x$.
tan-odd | Simplify $\tan(-x)$. | $-\tan x$.
sin-cofunction | Simplify $\sin(\pi/2-x)$. | $\cos x$.
cos-cofunction | Simplify $\cos(\pi/2-x)$. | $\sin x$.
tan-cofunction | Simplify $\tan(\pi/2-x)$. | $\cot x$.
sin-double | Expand $\sin(2x)$. | $\sin(2x)=2\sin x\cos x$.
cos-double | Expand $\cos(2x)$ using both sine and cosine. | $\cos(2x)=\cos^2x-\sin^2x$.
cos-double-sin | Express $\cos(2x)$ using only sine. | $\cos(2x)=1-2\sin^2x$.
cos-double-cos | Express $\cos(2x)$ using only cosine. | $\cos(2x)=2\cos^2x-1$.
tan-double | Expand $\tan(2x)$. | $\tan(2x)=\dfrac{2\tan x}{1-\tan^2x}$.
sin-square | Reduce the power in $\sin^2x$. | $\sin^2x=(1-\cos2x)/2$.
cos-square | Reduce the power in $\cos^2x$. | $\cos^2x=(1+\cos2x)/2$.
sin-half | Half-angle formula for $\sin^2(x/2)$? | $\sin^2(x/2)=(1-\cos x)/2$. A square root requires the correct sign.
cos-half | Half-angle formula for $\cos^2(x/2)$? | $\cos^2(x/2)=(1+\cos x)/2$. A square root requires the correct sign.
tan-half-a | Express $\tan(x/2)$ with denominator $1+\cos x$. | $\tan(x/2)=\sin x/(1+\cos x)$.
tan-half-b | Express $\tan(x/2)$ with denominator $\sin x$. | $\tan(x/2)=(1-\cos x)/\sin x$.
product-ss | Convert $\sin a\sin b$ to a sum. | $\sin a\sin b=\tfrac12[\cos(a-b)-\cos(a+b)]$.
product-cc | Convert $\cos a\cos b$ to a sum. | $\cos a\cos b=\tfrac12[\cos(a-b)+\cos(a+b)]$.
product-sc | Convert $\sin a\cos b$ to a sum. | $\sin a\cos b=\tfrac12[\sin(a+b)+\sin(a-b)]$.
tan-square | Rewrite $\tan^2x$ using secant. | $\tan^2x=\sec^2x-1$.
cot-square | Rewrite $\cot^2x$ using cosecant. | $\cot^2x=\csc^2x-1$.
sin-cos | Rewrite $\sin x\cos x$ using a double angle. | $\sin x\cos x=\tfrac12\sin2x$.
sin2-cos2 | Reduce $\sin^2x\cos^2x$ for integration. | $\sin^2x\cos^2x=\tfrac18(1-\cos4x)$.
sin4 | Reduce $\sin^4x$ for integration. | $\sin^4x=\tfrac18(3-4\cos2x+\cos4x)$.
cos4 | Reduce $\cos^4x$ for integration. | $\cos^4x=\tfrac18(3+4\cos2x+\cos4x)$.
sqrt-sec | Simplify $\sqrt{\sec^2\theta}$. | $|\sec\theta|$.
''', 'Angles are in radians. Quotient identities hold wherever every displayed expression is defined.')
for fn,p in [('sin',r'2\pi'),('cos',r'2\pi'),('tan',r'\pi'),('cot',r'\pi'),('sec',r'2\pi'),('csc',r'2\pi')]:
    card(f'{fn}-period',f'Fundamental period of $\\{fn} x$?',f'${p}$.')
for name, sign, opposite in [('sum','+','-'),('difference','-','+')]:
    for fn,rhs in [('sin',rf'\sin a\cos b{sign}\cos a\sin b'),('cos',rf'\cos a\cos b{opposite}\sin a\sin b'),('tan',rf'\dfrac{{\tan a{sign}\tan b}}{{1{opposite}\tan a\tan b}}')]:
        card(f'{fn}-{name}',rf'Expand $\{fn}(a{sign}b)$.',rf'$\{fn}(a{sign}b)={rhs}$.','Where all expressions are defined.')

topic('trig-calculus', 'Trigonometric derivatives and integrals')
for fn, derivative in [('sin',r'\cos x'),('cos',r'-\sin x'),('tan',r'\sec^2x'),('cot',r'-\csc^2x'),('sec',r'\sec x\tan x'),('csc',r'-\csc x\cot x')]:
    card(f'd-{fn}',rf'Differentiate $\{fn} x$.',rf'$\dfrac{{d}}{{dx}}\{fn} x={derivative}$.','Angles are in radians; work on the function’s domain.')
for key,f,F in [('sin',r'\sin x',r'-\cos x'),('cos',r'\cos x',r'\sin x'),('sec2',r'\sec^2x',r'\tan x'),('csc2',r'\csc^2x',r'-\cot x'),('sectan',r'\sec x\tan x',r'\sec x'),('csccot',r'\csc x\cot x',r'-\csc x'),('tan',r'\tan x',r'-\ln|\cos x|'),('cot',r'\cot x',r'\ln|\sin x|'),('sec',r'\sec x',r'\ln|\sec x+\tan x|'),('csc',r'\csc x',r'\ln|\csc x-\cot x|')]:
    card(f'i-{key}',rf'Evaluate $\int {f}\,dx$.',rf'$\int {f}\,dx={F}+C$.','On an interval where the integrand is defined; angles are in radians.')
rows(r'''
asin-range | Domain and principal range of $\arcsin$? | $\arcsin:[-1,1]\to[-\pi/2,\pi/2]$.
acos-range | Domain and principal range of $\arccos$? | $\arccos:[-1,1]\to[0,\pi]$.
atan-range | Domain and principal range of $\arctan$? | $\arctan:\mathbb R\to(-\pi/2,\pi/2)$.
inverse-reciprocal | Does $\sin^{-1}x$ mean a reciprocal? | Conventionally it means $\arcsin x$, the principal inverse function. The reciprocal is written $\csc x$.
d-asin | Differentiate $\arcsin x$. | $\dfrac{d}{dx}\arcsin x=1/\sqrt{1-x^2}$ for $|x|<1$.
d-acos | Differentiate $\arccos x$. | $\dfrac{d}{dx}\arccos x=-1/\sqrt{1-x^2}$ for $|x|<1$.
d-atan | Differentiate $\arctan x$. | $\dfrac{d}{dx}\arctan x=1/(1+x^2)$.
i-asin | Evaluate $\int dx/\sqrt{a^2-x^2}$ for $a>0$. | $\arcsin(x/a)+C$, for $|x|<a$.
i-atan | Evaluate $\int dx/(a^2+x^2)$ for $a>0$. | $\dfrac1a\arctan(x/a)+C$.
sub-sin | Trigonometric substitution for $\sqrt{a^2-x^2}$, $a>0$? | $x=a\sin\theta$, with $-\pi/2\leq\theta\leq\pi/2$.
sub-tan | Trigonometric substitution for $\sqrt{a^2+x^2}$, $a>0$? | $x=a\tan\theta$, with $-\pi/2<\theta<\pi/2$.
sub-sec | Trigonometric substitution for $\sqrt{x^2-a^2}$, $a>0$? | $x=a\sec\theta$. Choose an interval matching the sign of $x$ and retain absolute values when simplifying radicals.
''')

topic('hyperbolic', 'Hyperbolic definitions and identities')
rows(r'''
sinh | Define $\sinh x$ using exponentials. | $\sinh x=(e^x-e^{-x})/2$.
cosh | Define $\cosh x$ using exponentials. | $\cosh x=(e^x+e^{-x})/2$.
tanh | Define $\tanh x$ using sinh and cosh. | $\tanh x=\sinh x/\cosh x$.
tanh-exp | Express $\tanh x$ using exponentials. | $\tanh x=(e^{2x}-1)/(e^{2x}+1)$.
sech | Define $\operatorname{sech}x$. | $\operatorname{sech}x=1/\cosh x$.
csch | Define $\operatorname{csch}x$. | $\operatorname{csch}x=1/\sinh x$, for $x\ne0$.
coth | Define $\coth x$. | $\coth x=\cosh x/\sinh x$, for $x\ne0$.
fundamental | Fundamental hyperbolic identity? | $\cosh^2x-\sinh^2x=1$.
tanh-identity | Hyperbolic identity involving tanh and sech? | $1-\tanh^2x=\operatorname{sech}^2x$.
coth-identity | Hyperbolic identity involving coth and csch? | $\coth^2x-1=\operatorname{csch}^2x$, for $x\ne0$.
sinh-odd | Simplify $\sinh(-x)$. | $-\sinh x$.
cosh-even | Simplify $\cosh(-x)$. | $\cosh x$.
tanh-odd | Simplify $\tanh(-x)$. | $-\tanh x$.
sinh-double | Expand $\sinh(2x)$. | $\sinh(2x)=2\sinh x\cosh x$.
cosh-double | Expand $\cosh(2x)$. | $\cosh(2x)=\cosh^2x+\sinh^2x$.
sinh-square | Reduce $\sinh^2x$. | $\sinh^2x=(\cosh2x-1)/2$.
cosh-square | Reduce $\cosh^2x$. | $\cosh^2x=(\cosh2x+1)/2$.
exp-plus | Simplify $\cosh x+\sinh x$. | $e^x$.
exp-minus | Simplify $\cosh x-\sinh x$. | $e^{-x}$.
''')
for name,sign in [('sum','+'),('difference','-')]:
    for fn,rhs in [('sinh',rf'\sinh a\cosh b{sign}\cosh a\sinh b'),('cosh',rf'\cosh a\cosh b{sign}\sinh a\sinh b')]:
        card(f'{fn}-{name}',rf'Expand $\{fn}(a{sign}b)$.',rf'$\{fn}(a{sign}b)={rhs}$.')

topic('hyperbolic-calculus', 'Hyperbolic derivatives, integrals and inverses')
for fn,derivative in [(r'\sinh',r'\cosh x'),(r'\cosh',r'\sinh x'),(r'\tanh',r'\operatorname{sech}^2x'),(r'\coth',r'-\operatorname{csch}^2x'),(r'\operatorname{sech}',r'-\operatorname{sech}x\tanh x'),(r'\operatorname{csch}',r'-\operatorname{csch}x\coth x')]:
    key=fn.replace('\\','').replace('operatorname','').strip('{}')
    card(f'd-{key}',f'Differentiate ${fn} x$.',rf'$\dfrac{{d}}{{dx}}{fn} x={derivative}$.','Where the function is defined.')
rows(r'''
i-sinh | Evaluate $\int\sinh x\,dx$. | $\cosh x+C$.
i-cosh | Evaluate $\int\cosh x\,dx$. | $\sinh x+C$.
i-tanh | Evaluate $\int\tanh x\,dx$. | $\ln(\cosh x)+C$.
asinh | Logarithmic formula for $\operatorname{arsinh}x$? | $\operatorname{arsinh}x=\ln(x+\sqrt{x^2+1})$, for all real $x$.
acosh | Logarithmic formula for $\operatorname{arcosh}x$? | $\operatorname{arcosh}x=\ln(x+\sqrt{x^2-1})$, for $x\geq1$, with nonnegative output.
atanh | Logarithmic formula for $\operatorname{artanh}x$? | $\operatorname{artanh}x=\tfrac12\ln\!\left(\frac{1+x}{1-x}\right)$, for $|x|<1$.
d-asinh | Differentiate $\operatorname{arsinh}x$. | $\dfrac{d}{dx}\operatorname{arsinh}x=1/\sqrt{x^2+1}$.
d-acosh | Differentiate $\operatorname{arcosh}x$. | $\dfrac{d}{dx}\operatorname{arcosh}x=1/\sqrt{x^2-1}$ for $x>1$.
d-atanh | Differentiate $\operatorname{artanh}x$. | $\dfrac{d}{dx}\operatorname{artanh}x=1/(1-x^2)$ for $|x|<1$.
sub-sinh | Hyperbolic substitution for $\sqrt{x^2+a^2}$, $a>0$? | $x=a\sinh u$.
sub-cosh | Hyperbolic substitution for $\sqrt{x^2-a^2}$ when $x\geq a>0$? | $x=a\cosh u$, with $u\geq0$.
''')

topic('coordinates', 'Polar, cylindrical and spherical coordinates')
coordinate_note = 'Convention: r is distance from the z-axis (or the planar origin); rho is distance from the 3D origin; theta is azimuth; phi is measured down from the positive z-axis. Angles are in radians.'
rows(r'''
convention | Which angle is $\phi$ in this deck’s spherical coordinates? | $\phi$ is measured down from the positive $z$-axis. Some books swap the angle symbols.
polar-x | Polar to Cartesian: formula for $x$? | $x=r\cos\theta$.
polar-y | Polar to Cartesian: formula for $y$? | $y=r\sin\theta$.
polar-r | Cartesian to polar: formula for $r$? | $r=\sqrt{x^2+y^2}$.
polar-theta | Cartesian to polar: formula for $\theta$? | $\theta=\operatorname{atan2}(y,x)$, adjusted to $[0,2\pi)$; undefined at the origin.
atan2 | Why use atan2 instead of $\arctan(y/x)$? | It selects the correct quadrant and handles $x=0$ away from the origin.
polar-range-r | Standard range for polar radius? | $r\geq0$.
polar-range-theta | Standard range for polar angle? | $0\leq\theta<2\pi$; the angle is arbitrary at the origin.
polar-area | Polar area element? | $dA=r\,dr\,d\theta$.
polar-enclosed | Area swept by a polar curve on $[\alpha,\beta]$? | $A=\tfrac12\int_\alpha^\beta r(\theta)^2\,d\theta$, counting the region once.
cyl-x | Cylindrical to Cartesian: formula for $x$? | $x=r\cos\theta$.
cyl-y | Cylindrical to Cartesian: formula for $y$? | $y=r\sin\theta$.
cyl-z | Cylindrical to Cartesian: formula for height? | $z_{\mathrm{Cartesian}}=z_{\mathrm{cylindrical}}$.
cart-cyl-r | Cartesian to cylindrical: formula for $r$? | $r=\sqrt{x^2+y^2}$.
cart-cyl-theta | Cartesian to cylindrical: formula for $\theta$? | $\theta=\operatorname{atan2}(y,x)$, adjusted to $[0,2\pi)$; arbitrary on the $z$-axis.
cart-cyl-z | Cartesian to cylindrical: formula for height? | $z_{\mathrm{cylindrical}}=z_{\mathrm{Cartesian}}$.
cyl-volume | Cylindrical volume element? | $dV=r\,dr\,d\theta\,dz$.
sph-x | Spherical to Cartesian: formula for $x$? | $x=\rho\sin\phi\cos\theta$.
sph-y | Spherical to Cartesian: formula for $y$? | $y=\rho\sin\phi\sin\theta$.
sph-z | Spherical to Cartesian: formula for $z$? | $z=\rho\cos\phi$.
cart-sph-rho | Cartesian to spherical: formula for $\rho$? | $\rho=\sqrt{x^2+y^2+z^2}$.
cart-sph-theta | Cartesian to spherical: formula for $\theta$? | $\theta=\operatorname{atan2}(y,x)$, adjusted to $[0,2\pi)$; arbitrary on the $z$-axis.
cart-sph-phi | Cartesian to spherical: formula for $\phi$? | $\phi=\arccos(z/\rho)$ for $\rho>0$; arbitrary at the origin.
sph-range-rho | Standard range for spherical radius? | $\rho\geq0$.
sph-range-theta | Standard range for spherical azimuth? | $0\leq\theta<2\pi$.
sph-range-phi | Standard range for spherical polar angle? | $0\leq\phi\leq\pi$.
sph-cyl-r | Spherical to cylindrical: formula for $r$? | $r=\rho\sin\phi$.
sph-cyl-z | Spherical to cylindrical: formula for $z$? | $z=\rho\cos\phi$.
sph-cyl-theta | Spherical to cylindrical: formula for azimuth? | $\theta_{\mathrm{cylindrical}}=\theta_{\mathrm{spherical}}$.
cyl-sph-rho | Cylindrical to spherical: formula for $\rho$? | $\rho=\sqrt{r^2+z^2}$.
cyl-sph-phi | Cylindrical to spherical: formula for $\phi$? | $\phi=\operatorname{atan2}(r,z)$ in $[0,\pi]$, away from the origin.
cyl-sph-theta | Cylindrical to spherical: formula for azimuth? | $\theta_{\mathrm{spherical}}=\theta_{\mathrm{cylindrical}}$.
sph-volume | Spherical volume element? | $dV=\rho^2\sin\phi\,d\rho\,d\phi\,d\theta$.
sphere-area | Surface area element on a sphere of radius $R$? | $dS=R^2\sin\phi\,d\phi\,d\theta$.
surface-cyl-r | Describe the cylindrical coordinate surface $r=a>0$. | A circular cylinder of radius $a$ around the $z$-axis.
surface-cyl-theta | Describe the cylindrical coordinate surface $\theta=\alpha$. | A vertical half-plane bounded by the $z$-axis.
surface-cyl-z | Describe the cylindrical coordinate surface $z=c$. | A horizontal plane at height $c$.
surface-sph-rho | Describe the spherical coordinate surface $\rho=a>0$. | A sphere of radius $a$ centered at the origin.
surface-sph-phi | Describe the spherical coordinate surface $\phi=\alpha$. | One nappe of a cone for $0<\alpha<\pi$, except $\alpha=\pi/2$ gives the $xy$-plane; endpoints give the positive or negative $z$-axis.
surface-sph-theta | Describe the spherical coordinate surface $\theta=\alpha$. | A vertical half-plane bounded by the $z$-axis.
''', coordinate_note)

topic('exp-log', 'Exponential and logarithmic definitions and identities')
rows(r'''
ln | Define the natural logarithm by an integral. | $\ln x=\int_1^x dt/t$, for $x>0$.
exp | Define the natural exponential using ln. | $\exp=\ln^{-1}$: the inverse function of $\ln$.
e | Define $e$ using exp. | $e=\exp(1)$.
exp-notation | How are $e^x$ and exp related? | $e^x=\exp(x)$.
real-power | Define $a^x$ for real $x$ and $a>0$. | $a^x=e^{x\ln a}$.
log | Define a logarithm with base $a$. | $\log_a x=y\iff a^y=x$, with $a>0$, $a\ne1$, $x>0$.
ln-exp | Simplify $\ln(e^x)$. | $x$, for every real $x$.
exp-ln | Simplify $e^{\ln x}$. | $x$, for $x>0$.
power-zero | Evaluate $a^0$ for $a>0$. | $1$.
power-one | Evaluate $a^1$ for $a>0$. | $a$.
log-one | Evaluate $\log_a1$. | $0$, for $a>0$, $a\ne1$.
log-base | Evaluate $\log_a a$. | $1$, for $a>0$, $a\ne1$.
exp-product | Expand $a^{u+v}$ for $a>0$. | $a^{u+v}=a^ua^v$.
exp-quotient | Expand $a^{u-v}$ for $a>0$. | $a^{u-v}=a^u/a^v$.
power-power | Simplify $(a^u)^v$ for $a>0$. | $(a^u)^v=a^{uv}$.
negative-power | Rewrite $a^{-x}$ for $a>0$. | $a^{-x}=1/a^x$.
root | Interpret $a^{1/n}$ for $a>0$ and positive integer $n$. | $a^{1/n}=\sqrt[n]{a}$.
log-product | Expand $\ln(xy)$ for $x,y>0$. | $\ln(xy)=\ln x+\ln y$.
log-quotient | Expand $\ln(x/y)$ for $x,y>0$. | $\ln(x/y)=\ln x-\ln y$.
log-power | Expand $\ln(x^r)$ for $x>0$. | $\ln(x^r)=r\ln x$.
change-base | Change $\log_a x$ to natural logarithms. | $\log_a x=\ln x/\ln a$, for $x>0$, $a>0$, $a\ne1$.
log-sum | Is $\ln(x+y)=\ln x+\ln y$ a valid identity? | No. Logarithms turn products into sums; there is no corresponding general rule for a sum.
log-square | Expand $\ln(x^2)$ for $x\ne0$. | $\ln(x^2)=2\ln|x|$.
''')

topic('exp-log-calculus', 'Exponential and logarithmic calculus')
rows(r'''
d-exp | Differentiate $e^x$. | $\dfrac{d}{dx}e^x=e^x$.
d-base | Differentiate $a^x$ for $a>0$. | $\dfrac{d}{dx}a^x=a^x\ln a$.
d-ln | Differentiate $\ln x$ for $x>0$. | $\dfrac{d}{dx}\ln x=1/x$.
d-ln-abs | Differentiate $\ln|x|$ for $x\ne0$. | $\dfrac{d}{dx}\ln|x|=1/x$.
d-log | Differentiate $\log_a x$. | $\dfrac{d}{dx}\log_a x=1/(x\ln a)$, for $x>0$, $a>0$, $a\ne1$.
chain-exp | Differentiate $e^{u(x)}$. | $\dfrac{d}{dx}e^{u(x)}=u'(x)e^{u(x)}$.
chain-ln | Differentiate $\ln|u(x)|$. | $\dfrac{d}{dx}\ln|u(x)|=u'(x)/u(x)$, where $u(x)\ne0$.
i-exp | Evaluate $\int e^x\,dx$. | $e^x+C$.
i-base | Evaluate $\int a^x\,dx$ for $a>0$, $a\ne1$. | $a^x/\ln a+C$.
i-log-pattern | Evaluate $\int u'(x)/u(x)\,dx$. | $\ln|u(x)|+C$, on an interval where $u\ne0$.
i-ln | Evaluate $\int\ln x\,dx$ for $x>0$. | $x\ln x-x+C$.
variable-power | Differentiate $u(x)^{v(x)}$ for $u(x)>0$. | $\dfrac{d}{dx}u^v=u^v\left(v'\ln u+v\dfrac{u'}u\right)$.
''')

topic('calculus-rules', 'Differentiation and integration rules')
rows(r'''
product | State the product rule. | $(fg)'=f'g+fg'$.
quotient | State the quotient rule. | $(f/g)'=(f'g-fg')/g^2$, where $g\ne0$.
chain | State the chain rule. | $(f(g(x)))'=f'(g(x))g'(x)$.
power | Differentiate $x^n$. | $\dfrac{d}{dx}x^n=nx^{n-1}$ on its differentiability domain; for arbitrary real $n$, take $x>0$.
power-integral | Integrate $x^n$ when $n\ne-1$. | $\int x^n\,dx=x^{n+1}/(n+1)+C$ on an appropriate domain; for arbitrary real $n$, take $x>0$.
parts | State integration by parts. | $\int u\,dv=uv-\int v\,du$.
substitution | State the indefinite substitution rule, with $F'=f$. | $\int f(g(x))g'(x)\,dx=F(g(x))+C$.
odd | Integral of an integrable odd function over $[-a,a]$? | $\int_{-a}^a f(x)\,dx=0$.
even | Integral of an integrable even function over $[-a,a]$? | $\int_{-a}^a f(x)\,dx=2\int_0^a f(x)\,dx$.
reflection | State the reflection identity for a definite integral. | $\int_a^b f(x)\,dx=\int_a^b f(a+b-x)\,dx$, for integrable $f$.
ftc | Evaluate a definite integral using an antiderivative $F$ of continuous $f$. | $\int_a^b f(x)\,dx=F(b)-F(a)$.
variable-bounds | Differentiate an integral of continuous $f$ with differentiable bounds $u,v$. | $\dfrac{d}{dx}\int_{u(x)}^{v(x)}f(t)\,dt=f(v(x))v'(x)-f(u(x))u'(x)$.
''', 'Differentiation rules assume the indicated functions are differentiable. Symmetry does not by itself establish convergence of an improper integral; ordinary improper integrals must converge, not merely have a principal value.')

topic('algebra', 'Algebra for calculus')
rows(r'''
squares | Factor $a^2-b^2$. | $a^2-b^2=(a-b)(a+b)$.
cubes-sum | Factor $a^3+b^3$. | $a^3+b^3=(a+b)(a^2-ab+b^2)$.
cubes-difference | Factor $a^3-b^3$. | $a^3-b^3=(a-b)(a^2+ab+b^2)$.
complete-square | Complete the square in $ax^2+bx+c$, $a\ne0$. | $ax^2+bx+c=a\left(x+\frac{b}{2a}\right)^2+c-\frac{b^2}{4a}$.
conjugate | Simplify $(\sqrt A-\sqrt B)(\sqrt A+\sqrt B)$ for $A,B\geq0$. | $A-B$.
sqrt-square | Simplify $\sqrt{x^2}$ for real $x$. | $|x|$.
geometric-finite | Sum $\sum_{k=0}^n r^k$ for $r\ne1$. | $\sum_{k=0}^n r^k=(1-r^{n+1})/(1-r)$, for nonnegative integer $n$.
geometric-infinite | Sum $\sum_{k=0}^\infty r^k$ and state its convergence condition. | $\sum_{k=0}^\infty r^k=1/(1-r)$ for $|r|<1$.
''')

topic('limits-series', 'Limits, Taylor series and small-angle behavior')
rows(r'''
limit-sin | Evaluate $\lim_{x\to0}\sin x/x$. | $1$, with angles in radians.
limit-cos | Evaluate $\lim_{x\to0}(1-\cos x)/x$. | $0$, with angles in radians.
limit-exp | Evaluate $\lim_{x\to0}(e^x-1)/x$. | $1$.
limit-log | Evaluate $\lim_{x\to0}\ln(1+x)/x$. | $1$.
limit-e | Give a limit representation of $e$. | $e=\lim_{n\to\infty}(1+1/n)^n$.
series-exp | Maclaurin series for $e^x$ and its real convergence domain? | $e^x=\sum_{n=0}^\infty x^n/n!$, for all real $x$.
series-sin | Maclaurin series for $\sin x$ and its real convergence domain? | $\sin x=\sum_{n=0}^\infty(-1)^n x^{2n+1}/(2n+1)!$, for all real $x$.
series-cos | Maclaurin series for $\cos x$ and its real convergence domain? | $\cos x=\sum_{n=0}^\infty(-1)^n x^{2n}/(2n)!$, for all real $x$.
series-log | Maclaurin series for $\ln(1+x)$ and its real convergence domain? | $\ln(1+x)=\sum_{n=1}^\infty(-1)^{n+1}x^n/n$, for $-1<x\leq1$.
series-atan | Maclaurin series for $\arctan x$ and its real convergence domain? | $\arctan x=\sum_{n=0}^\infty(-1)^n x^{2n+1}/(2n+1)$, for $|x|\leq1$.
asymptotic-meaning | What does $f(x)\sim g(x)$ as $x\to0$ mean? | $\lim_{x\to0}f(x)/g(x)=1$, with the ratio defined near zero.
small-sin | Leading equivalent of $\sin x$ as $x\to0$? | $\sin x\sim x$ (radians).
small-tan | Leading equivalent of $\tan x$ as $x\to0$? | $\tan x\sim x$ (radians).
small-cos | Leading equivalent of $1-\cos x$ as $x\to0$? | $1-\cos x\sim x^2/2$ (radians).
small-exp | Leading equivalent of $e^x-1$ as $x\to0$? | $e^x-1\sim x$.
small-log | Leading equivalent of $\ln(1+x)$ as $x\to0$? | $\ln(1+x)\sim x$.
''')

topic('complex-exponentials', 'Euler’s formula and complex exponentials')
rows(r'''
euler | State Euler’s formula for real $x$. | $e^{ix}=\cos x+i\sin x$, where $i^2=-1$ and $x$ is in radians.
cos | Express $\cos x$ using complex exponentials. | $\cos x=(e^{ix}+e^{-ix})/2$.
sin | Express $\sin x$ using complex exponentials. | $\sin x=(e^{ix}-e^{-ix})/(2i)$.
''')

def write(name, value):
    (ROOT/name).write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

stages=[]
levels=[]
allcards=[]
for t in topics:
    file=t['slug']+'.json'
    write(file,t['cards'])
    ids=[c['id'] for c in t['cards']]
    stages.append(dict(stage=t['stage'],title=t['title'],file=file,card_ids=ids))
    levels.append(dict(id='calculus-'+t['slug'],title=t['title'],requires=[],card_ids=ids))
    allcards.extend(t['cards'])
write('manifest.json',dict(title='Calculus reference',version=1,stages=stages,cards=[dict(id=c['id'],stage=c['stage'],topic=c['topic'],type=c['type']) for c in allcards]))
write('unlock-levels.json',dict(version=1,policy='manual-unlock',default_unlocked=[l['id'] for l in levels],levels=levels))
print(f'Generated {len(allcards)} cards in {len(topics)} topics.')
