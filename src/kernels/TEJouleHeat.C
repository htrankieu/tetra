#include "TEJouleHeat.h"

registerMooseObject("TetraApp", TEJouleHeat);

InputParameters
TEJouleHeat::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addParam<MaterialPropertyName>("current_density",
                                        "Current density material for Joule heating.");

  params.addRequiredCoupledVar("elec", "Electrical potential variable");
  params.addClassDescription("Calculates the heat source term corresponding to electrostatic Joule "
                             "heating.");
  return params;
}

TEJouleHeat::TEJouleHeat(const InputParameters & parameters)
  : ADKernelValue(parameters),
    _J(getADMaterialProperty<RealVectorValue>("current_density")),
    _grad_elec(adCoupledGradient("elec"))
{
}

ADReal
TEJouleHeat::precomputeQpResidual()
{
  using std::abs;

  // return -(_grad_elec[_qp] * _J[_qp]);
  return -abs(_grad_elec[_qp] * _J[_qp]);
  // return -std::abs(_grad_elec[_qp] * _J[_qp]);
}
