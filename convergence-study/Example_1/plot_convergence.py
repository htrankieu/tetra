import mms

df1 = mms.run_spatial("pleg_cuboid.i", 2, console=False, executable="../../tetra-opt", x_pp="h", y_pp=["elecerror", "heaterror"])
df2 = mms.run_spatial(
    "pleg_cuboid.i",
    2,
    "Mesh/second_order=true",
    "Variables/u/order=SECOND",
    console=False,
    executable="../../tetra-opt", x_pp="h", y_pp=["elecerror", "heaterror"]
)

fig = mms.ConvergencePlot(xlabel="Element Size ($h$)", ylabel="$L_2$ Error")
fig.plot(df1, label=["1st Order Elec", "1st Order Heat"], marker="o", markersize=8)
fig.plot(df2, label=["2nd Order Elec", "2nd Order Heat"], marker="o", markersize=8)
fig.save("mms_spatial.png")