// Including the "ADKernel" base class here so we can extend it
#include "ADKernelValue.h"

/**
 * Computes the residual contribution: grad_u - S(T) * grad_temp
 */
class JouleHeating_Seebeck : public ADKernelValue
{
public:
  static InputParameters validParams();

  JouleHeating_Seebeck(const InputParameters & parameters);

protected:
  /// ADKernel objects must override precomputeQpResidual
  virtual ADReal precomputeQpResidual() override;

  /// The variables which hold the value for seabeck
  const ADVariableGradient & _grad_elec;

  const ADMaterialProperty<Real> & _seebeck;
  const ADMaterialProperty<Real> & _resistivity;
};
