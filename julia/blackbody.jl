using Images

# this file is for every temperature/redshift/blackbody related function

#accretion disk log temperature profile (R^{-3/4})
LOGSHIFT = 0.823959216501 # 3/4 log(3)
function disktemp(sqrR::AbstractArray, logT0::Float64)
    # sqrR is an array of R^2
    # logT0 is log temperature (K) of accretion disk at ISCO

    A::Float64 = logT0 + LOGSHIFT

    return A .- (0.375 * log.(sqrR))
end

#blackbody temperature (abs, not log) -> relative intensity (absolute, not log)
#T is an array of abs temperatures

#this is basically planck's law integrated over the visible spectrum, which is assumed
#infinitesimal. The actual constant could have been computed but it was safer
#and faster to gnuplot-fit it with a gradient from http://www.vendian.org/mncharity/dir3/blackbody/intensity.html
intensity(T::AbstractArray) = 1 ./ ( ℯ.^(29622.4 ./ map(x -> x < 1 ? 1 : x, T)) .- 1)


# ramp = spm.imread('data/colourtemp.jpg')[0,:,:]/255.
ramp = load("data/colourtemp.jpg")[0,:]
#rampsz = ramp.shape[0]


#function colour(T)
#    indices = np.clip( (T-1000)/29000. * rampsz,0.,rampsz-1.0001)
#
#    return ramp[indices.astype(np.int),:]
#end