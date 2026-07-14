!config navigation breadcrumbs=False scrollspy=False

# TETRA

## ThermoElectric Transport and Response Analysis

This MOOSE-based application is used to solve the coupled current continuity and heat conduction equations in the presence of Seebeck, Peltier, and Thomson effects.

The weak form of the heat conduction equation is:
\begin{equation}
    \int_\Omega k \vec{\nabla} T \cdot  \nabla \phi~d\Omega
     -  \int_\Omega ST \vec{J} \cdot  \nabla \phi~d\Omega+ \int_\Omega q_J \phi~d\Omega  + \int_\Gamma  \left(-k\vec{\nabla} T + ST \vec{J} \right) \cdot \vec{n}~d\Gamma = 0
\end{equation}
The weak form of the current continuity equation is:
\begin{equation}
      - \int_\Omega \sigma \vec{\nabla} V \cdot  \vec{\nabla}\phi~d\Omega    -  \int_\Omega \sigma S \vec{\nabla} T \cdot  \vec{\nabla}~d\Omega
      + \int_\Gamma\sigma \left(  \vec{\nabla} V + S\vec{\nabla} T\right)\cdot \vec{n}~d\Gamma = 0
\end{equation}
