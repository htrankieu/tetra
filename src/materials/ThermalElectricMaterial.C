#include "ThermalElectricMaterial.h"
#include "Function.h"
#include "libmesh/quadrature.h"

registerMooseObject("TetraApp", ThermalElectricMaterial);
registerMooseObject("TetraApp", ADThermalElectricMaterial);

template <bool is_ad>
InputParameters
ThermalElectricMaterialTempl<is_ad>::validParams()
{
  InputParameters params = Material::validParams();

  params.addCoupledVar("temp", "Coupled Temperature");
  params.addParam<Real>("seebeck", "Seebeck value");
  params.addParam<FunctionName>(
      "seebeck_temperature_function", "", "Seebeck as a function of temperature.");
  params.addParam<Real>("resistivity", "resistivity value");
  params.addParam<FunctionName>("resistivity_temperature_function",
                                "",
                                "Electrical resistivity as a function of temperature.");

  params.addClassDescription("General purpose Thermal Electric material to define"
                             "Seebeck coefficient and electric resistivity using constants or functions"
                             "and derived electric conductivity, Thomson and Peltier coefficients");

  return params;
}

template <bool is_ad>
ThermalElectricMaterialTempl<is_ad>::ThermalElectricMaterialTempl(
    const InputParameters & parameters)
  : Material(parameters),

    _has_temp(isCoupled("temp")),
    _temperature(_has_temp ? coupledGenericValue<is_ad>("temp") : genericZeroValue<is_ad>()),
    // checking if value is valid and assigned default to 0 if not given

    // Seebeck
    _my_seebeck(isParamValid("seebeck") ? getParam<Real>("seebeck") : 0),
    _seebeck(declareGenericProperty<Real, is_ad>("seebeck")),
    _seebeck_temperature_function(getParam<FunctionName>("seebeck_temperature_function") != ""
                                      ? &getFunction("seebeck_temperature_function")
                                      : nullptr),

    // resistivity
    _my_resistivity(isParamValid("resistivity") ? getParam<Real>("resistivity") : 0),
    _resistivity(declareGenericProperty<Real, is_ad>("resistivity")),
    _resistivity_temperature_function(getParam<FunctionName>("resistivity_temperature_function") !=
                                              ""
                                          ? &getFunction("resistivity_temperature_function")
                                          : nullptr),

    _Peltier(declareGenericProperty<Real, is_ad>("peltier")),
    _Thomson(declareGenericProperty<Real, is_ad>("thomson")),
    _elec_conductivity(declareGenericProperty<Real, is_ad>("elec_conductivity"))
{
  // check if seebeck and seebeck temperature function is both defined
  if (_seebeck_temperature_function && !_has_temp)
    paramError("Seebeck_temperature_function",
               "Must couple with temperature if using seebeck temperature function");

  if (isParamValid("seebeck") && _seebeck_temperature_function)
    mooseError("Cannot define both seebeck and seebeck_temperature_function");
  // check if resistivity and resistivity function is both defined

  if (_resistivity_temperature_function && !_has_temp)
    paramError("resistivity_temperature_function",
               "Must couple with temperature if using resistivity_temperature_function");

  if (isParamValid("resistivity") && _resistivity_temperature_function)
    mooseError("Cannot define both resistivity and resistivity_temperature_function");
}

template <bool is_ad>
void
ThermalElectricMaterialTempl<is_ad>::computeQpProperties()
{
  {
    // checking if temperature is below zero
    if (_has_temp)
    {
      if (_temperature[_qp] < 0)
      {
        std::stringstream msg;
        msg << "WARNING:  In HeatConductionMaterial:  negative temperature!\n"
            << "\tResetting to zero.\n"
            << "\t_qp: " << _qp << "\n"
            << "\ttemp: " << _temperature[_qp] << "\n"
            << "\telem: " << _current_elem->id() << "\n"
            << "\tproc: " << processor_id() << "\n";
        mooseError(msg.str());
      }
    }
    // if seebeck is a function of temperature
    if (_seebeck_temperature_function)
    {
      _seebeck[_qp] = _seebeck_temperature_function->value(_temperature[_qp]);

      _Thomson[_qp] =
          _seebeck_temperature_function->timeDerivative(MetaPhysicL::raw_value(_temperature[_qp])) *
          _temperature[_qp];
    }
    else
    {
      _seebeck[_qp] = _my_seebeck;
      _Thomson[_qp] = 0.;
    }

    if (_resistivity_temperature_function)
    {
      _resistivity[_qp] = _resistivity_temperature_function->value(_temperature[_qp]);
    }
    else
    {
      _resistivity[_qp] = _my_resistivity;
    }
    _Peltier[_qp] = _seebeck[_qp] * _temperature[_qp];

    using std::abs;
    // if (std::abs(_resistivity[_qp]) > 1e-12)
    if (abs(_resistivity[_qp]) > 1e-12)
    {
      _elec_conductivity[_qp] = 1 / _resistivity[_qp];
    }
    else
      _elec_conductivity[_qp] = 1e12;
  }
}

template class ThermalElectricMaterialTempl<false>;
template class ThermalElectricMaterialTempl<true>;
