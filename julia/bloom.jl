using SpecialFunctions
using DSP

# "airy disk" function (actually approximate, and a rescaling, but it's ok)
# see https://en.wikipedia.org/wiki/Bessel_function#Bessel_functions_of_the_first_kind:_J%CE%B1
airy_disk(x::AbstractArray) = (2 * besselj1.(x) ./ x).^2

# generate a (2*size+1,2*size+1) convolution kernel with "radii" scale
# where the function above is assumed to have "radius" one
# scale is a 3-vector for RGB
function generate_kernel(scale::AbstractArray, s::Int64)
    x = -s:s
    y = -s:s

    xs, ys = meshgrid(x, y)

    kernel = zeros(size(xs)[1], 3, size(xs)[2])

    r = sqrt.(xs.^2 + ys.^2) .+ 0.000001
    kernel = airy_disk(reshape(r, 21, 1, 21) ./ reshape(scale, 1,3,1))

    #normalization
    kernel ./= reshape(([kernel[:, i, :] for i = 1:3] .|> sum), 1,3,1)

    return kernel
end

const SPECTRUM = [1., 0.86, 0.61]

function airy_convolve(array, radius::Float64, kernel_radius=25)
    kernel = generate_kernel(radius * SPECTRUM , kernel_radius)

    out = zeros(size(array)[1], 3, size(array)[2])
    for i in range(3)
        out[:, i, :] = conv(array[:, i, :], kernel[:, i, :])
    end
    return out
end


######
function meshgrid(x,y)
    nx = length(x)
    ny = length(y)
    X = zeros(ny, nx)
    Y = zeros(ny, nx)

    for j=1:nx
        for i=1:ny
            X[i, j]= x[j]
            Y[i, j]= y[i]
        end
    end
    return X, Y
end