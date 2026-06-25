#include "JouleHeating_Seebeck.h"

registerMooseObject("TetraApp", JouleHeating_Seebeck);

InputParameters
JouleHeating_Seebeck::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addClassDescription("Compute the joule heating effect related by seebeck effect: "
                             "-$ \\sigma \\nabla u \\nabla T \\cdot \\nabla u \\phi $");
  params.addRequiredCoupledVar("elec", "elecitric potential for joule heating.");

  return params;
}

JouleHeating_Seebeck::JouleHeating_Seebeck(const InputParameters & parameters)
  : ADKernelValue(parameters),
    _grad_elec(adCoupledGradient("elec")),

    _seebeck(getADMaterialProperty<Real>("seebeck")),
    _resistivity(getADMaterialProperty<Real>("resistivity"))
{
}

ADReal
JouleHeating_Seebeck::precomputeQpResidual()
{
  return -(_seebeck[_qp] / _resistivity[_qp]) * _grad_u[_qp] * _grad_elec[_qp];
}
