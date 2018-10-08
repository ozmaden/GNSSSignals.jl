"""
$(SIGNATURES)

Generate carrier at sample points `samples` with frequency `f`, phase `φ₀` and sampling frequency `f_s`.
# Examples
```julia-repl
julia> gen_carrier(1:4000, 200Hz, 10 * π / 180, 4e6Hz)
```
"""
function gen_carrier(sample, f, φ₀, f_s)
    cis((2π * f / f_s) * sample + φ₀)
end

"""
$(SIGNATURES)

Calculate carrier phase at sample point `sample` with frequency `f`, phase `φ₀` and sampling frequency `f_s`.
# Examples
```julia-repl
julia> get_carrier_phase(4000, 200Hz, 10 * π / 180, 4e6Hz)
```
"""
function get_carrier_phase(sample, f, φ₀, f_s)
    mod2pi((2 * π * f / f_s) * sample + φ₀)
end

"""
$(SIGNATURES)

Generate sampled code at sample points `samples` with the code frequency `f`, code phase `φ₀` and sampling
frequency `f_s`. The code is provided by `code`.
# Examples
```julia-repl
julia> gen_code(1:4000, 1023e3Hz, 2, 4e6Hz, [1, -1, 1, 1, 1])
```
"""
function gen_code(sample, f, φ₀, f_s, codes, prn)
    codes[1 + mod(floor(Int, f / f_s * sample + φ₀), size(codes, 1)), prn]
end

function gen_code(gnss_system::T, sample, f, φ₀, f_s, prn) where T <: AbstractGNSSSystem
    gen_code(sample, f, φ₀, f_s, gnss_system.codes, prn)
end

"""
$(SIGNATURES)

Calculates the code phase at sample point `sample` with the code frequency `f`, code phase `φ₀`, sampling
frequency `f_s` and code length `code_length`.
# Examples
```julia-repl
julia> calc_code_phase(4000, 1023e3Hz, 2, 4e6Hz, 1023)
```
"""
function calc_code_phase(sample, f, φ₀, f_s, code_length)
    mod(f / f_s * sample + φ₀ + code_length / 2, code_length) - code_length / 2
end
