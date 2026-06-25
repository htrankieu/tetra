//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "AuxKernel.h"

/**
 *  Calculates the current density vector field (in A/m^2) when given electrostatic
 *  potential (electrostatic = true, default) or electric field.
 */
template <bool is_ad>
class TECurrentDensityTempl : public VectorAuxKernel
{
public:
  static InputParameters validParams();

  TECurrentDensityTempl(const InputParameters & parameters);

protected:
  virtual RealVectorValue computeValue() override;

  /// Is the current density based on electrostatic potential?
  const bool & _is_es;

  /// Gradient of electrostatic potential
  const VariableGradient & _grad_potential;

  /// Electrical conductivity (in S/m)
  const GenericMaterialProperty<Real, is_ad> & _conductivity;
};

typedef TECurrentDensityTempl<false> TECurrentDensity;
typedef TECurrentDensityTempl<true> ADTECurrentDensity;
