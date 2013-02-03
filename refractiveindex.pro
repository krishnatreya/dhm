;+
; NAME:
;     refractiveindex
;
; PURPOSE:
;     Returns the real part of the refractive index of water
;     as a function of the wavelength of light and the
;     temperature
;
; CATEGORY:
;     Physical constants;
;
; CALLING SEQUENCE:
;     IDL> n = refractiveindex(lambda,T)
;
; INPUTS:
;     lambda: vacuum wavelength of light [micrometers]
;     T: temperature [C]
;
; OUTPUTS:
;     n: refractive index
;
; PROCEDURE:
;     The International Association for the Properties of Water
;     and Steam,
;     Release on the Refractive Index of Ordinary Water Substance
;     as a Function of Wavelength, Temperature and Pressure,
;     (1997)
;
;     http://www.iapws.org/relguide/rindex.pdf
;
; MODIFICATION HISTORY:
; 06/10/2007 Created by David G. Grier, New York University
; 03/01/2012 DGG: Spelling of Celsius (sheesh)
;
; Copyright (c) 2007-2012 David G. Grier    
;
;-

function refractiveindex, wavelength, temperature

;;; water
Tref = 273.15            ; [K] reference temperature -- freezing point of water
rhoref = 1000.           ; [kg/m^3] reference density
lambdaref = 0.589        ; [micrometer] reference wavelength

T = temperature/Tref + 1.       ; Temperature in degrees Celsius
;rho = density/rhoref
rho = 1.
lambda = wavelength/lambdaref

a0 = 0.244257773
a1 = 9.74634476d-3
a2 = -3.73234996d-3
a3 = 2.68678472d-4
a4 = 1.58920570d-3
a5 = 2.45934259d-3
a6 = 0.900704920
a7 = -1.66626219d-2

lambdauv = 0.2292020
lambdair = 5.432937

A = a0 + a1*rho + a2*T + a3*lambda^2*T + a4/lambda^2
A += a5/(lambda^2 - lambdauv^2)
A += a6/(lambda^2 - lambdair^2)
A += a7 * rho^2

A *= rho

n = sqrt((1.d + 2.d*A)/(1.d - A))

lambda = [0.442, 0.488, 0.5145, 0.543, 0.5682, $
          0.594, 0.6328, 0.6471, 0.6943, 0.890, 1.060]
nPMMA  = [1.4995, 1.4956, 1.4945, 1.4932, 1.4919, $
          1.4906, 1.4888, 1.4881, 1.4864, 1.4833, 1.4812]
nPS    = [1.6135, 1.6037, 1.5995, 1.5957, 1.5928, $
          1.5901, 1.5867, 1.5855, 1.5824, 1.5752, 1.5717]

return, n
end

