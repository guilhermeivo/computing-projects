# Sistema de Lorenz[^1]

[![Watch the video](media/images/lorenz/thumbnail.png)](media/videos/lorenz/1080p60/lorenz.mp4)

Sistema de equações diferenciais ordinárias (EDOs) de primeira ordem:

$$\left\lbrace\begin{array}{l}
\dfrac{dx}{dt}=\sigma(y-x)\\
\dfrac{dy}{dt}=x(\rho-z)-y\\
\dfrac{dz}{dt}=xy-\beta z
\end{array}\right.$$

Com os parâmetros clássicos:

$$\sigma = 10\quad\rho=28\quad\beta=\dfrac{8}{3}$$

A aproximação pelo método de Euler é dada por:

$$x(t+\Delta t)=x(t)+\dfrac{dx(t)}{dt}\Delta t$$

$$y(t+\Delta t)=y(t)+\dfrac{dy(t)}{dt}\Delta t$$

$$z(t+\Delta t)=z(t)+\dfrac{dz(t)}{dt}\Delta t$$

$$\Longrightarrow\begin{array}{l}
x(t+\Delta t)=x(t)+\left(\sigma(y-x)\right)\Delta t \\
y(t+\Delta t)=y(t)+\left(x(\rho-z)-y\right)\Delta t \\
z(t+\Delta t)=z(t)+\left(xy-\beta z\right)\Delta t
\end{array}$$

[^1]: EDWARD N. LORENZ. Deterministic Nonperiodic Flow. **Journal of the Atmospheric Science**, v. 20, n. 2, p. 130--141, 01 mar. 1963.