#docker run --rm -it -v ".:/manim" manimcommunity/manim manim -qh lorenz.py thumbnail -o thumbnail.png
#docker run --rm -it -v ".:/manim" manimcommunity/manim manim -qh lorenz.py main -o lorenz.mp4

import math 
from manim import *
from manim.typing import Point3D, Point3DLike

class Vector:
    def __init__(self, elements):
        if len(elements) != 0:
            self.elements = elements
        else:
            self.elements = []

    def __len__(self):
        return len(self.elements)

    def __add__(self, other):
        return Vector([ self.elements[i] + other.elements[i] for i in range(len(self)) ])

    def __getitem__(self, key):
        return self.elements[key]

class Glow_Dot(Dot):
    def __init__(
        self,
        point: Point3DLike = ORIGIN,
        radius: float = DEFAULT_DOT_RADIUS,
        color: ParsableManimColor = WHITE,
        **kwargs,
    ) -> None:
        super().__init__(
            point = point,
            radius = radius*(1.002**(1**2))/400,
            color = color,
            **kwargs,
        )

        glow_group = VGroup()
        for idx in range(60):
            new_circle = Circle(
                radius = radius*(1.002**(idx**2))/400, 
                stroke_opacity = 0, 
                fill_opacity = 0.2-idx/300,
                color = color
            ).move_to(point)
            glow_group.add(new_circle)
        self.add(glow_group)

def lorenz_system(state, sigma = 10.0, rho = 28.0, beta = 8.0 / 3.0):
    x, y, z, _ = state
    dx = sigma * (y - x)
    dy = x * (rho - z) - y
    dz = x * y - beta * z
    return ( dx, dy, dz )

def rates(r, dt):
    dx, dy, dz = lorenz_system(r)
    r0 = dx * dt
    r1 = dy * dt
    r2 = dz * dt

    r3 = dt
    return Vector([ r0, r1, r2, r3 ])

class thumbnail(Scene):
    def construct(self):
        title = Tex(r"\textbf{Lorenz System}").scale(1.15)
        self.add(title)

class main(MovingCameraScene):
    noise_std = 1e-3

    def construct(self):
        title = Tex(r"\textbf{Lorenz System}").scale(1.15).move_to(UP)
        description = MathTex(
            r"\begin{matrix}"
            r"\dot{X}=&&-\alpha X+\alpha Y\text{,}&\\"
            r"\dot{Y}=&-XZ&+\rho X-Y\text{,}&\\"
            r"\dot{Z}=&XY&&-\beta Z\text{.}"
            r"\end{matrix}"
        ).center().next_to(title, 2 * DOWN)
        references = Tex(
            r"EDWARD N. LORENZ. Deterministic Nonperiodic Flow. \textbf{Journal of the Atmospheric Sciences}, v. 20, n. 2, p. 130--141, 01 mar. 1963."
        ).scale(0.5).center().next_to(description, 2 * DOWN)
        self.play(Write(title), Write(description))
        self.play(Write(references))
        self.wait()
        self.play(FadeOut(title), FadeOut(references))
        self.play(FadeOut(description))
        self.wait()

        self.camera.frame.save_state()

        colors = [PURE_BLUE, PURE_GREEN, PURE_RED]

        axes = (
            Axes(
                x_range = [ -50, 50 ],
                y_range = [ -50, 50 ],
                x_length = 16,
                y_length = 9,
                tips = False,
            )
            .to_edge(DOWN)
        )
        axes.center()

        curves = VGroup()
        for index, item in enumerate(colors):
            np.random.seed(index)
            delta = np.random.normal(0, self.noise_std, size=3)

            x0 = 1.0 + delta[0]
            y0 = 1.0 + delta[1]
            z0 = 1.0 + delta[2]

            t0 = 0.0
            tn = 15.0
            dt = 0.01

            # states[0] = x
            # states[1] = y
            # states[2] = z
            # states[3] = time
            states = Vector([ x0, y0, z0, t0 ])
            trajetory = []

            # euler method
            while (states[3] < tn):
                trajetory.append(states)
                states = states + rates(states, dt)

            x = [a[0] for a in trajetory]
            y = [a[1] for a in trajetory]
            z = [a[2] for a in trajetory]

            time = [a[3] for a in trajetory]

            curve = VMobject()

            curve.set_points_as_corners( 
                [ [ xi, yi, zi ] for xi, yi, zi in zip(x, y, z) ]
            )
            curve.set_stroke(color=item, width=0.75)
            curve.scale(0.075)
            curve.center()

            curves.add(curve)

        glow_dots = VGroup(Glow_Dot(radius = 1, color = color) for curve, color in zip(curves, colors))

        self.play(
            *(
                Create(glow_dot)
                for glow_dot in glow_dots
            )
        )
        self.remove(
            *(
                glow_dot
                for glow_dot in glow_dots
            )
        )
        self.add(glow_dots)
        self.wait()
        self.play(self.camera.frame.animate.scale(0.75).move_to(glow_dots.get_center()))

        def update_dots(glow_dots, curves = curves):
            for glow_dot, curve in zip(glow_dots, curves):
                glow_dot.move_to(curve.get_end())
        glow_dots.add_updater(update_dots)

        def update_camera(camera, glow_dots = glow_dots):
            center_of_mass = (0.0, 0.0, 0.0)
            for index in range(min(len(glow_dots), 2)):
                center_of_mass += glow_dots[index].get_center()
            center_of_mass /= min(len(glow_dots), 2)
            camera.move_to(center_of_mass)

        self.camera.frame.add_updater(update_camera)

        self.play(
            *(
                Create(curve, rate_func = rate_functions.ease_out_sine)
                for curve in curves
            ), run_time = 20
        )

        self.camera.frame.remove_updater(update_camera)

        self.play(Restore(self.camera.frame))

        glow_dots.remove_updater(update_dots)

        self.wait(5)

        self.play(FadeOut(curves), FadeOut(glow_dots))
        self.wait()