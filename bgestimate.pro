;+
; NAME:
;    bgestimate
;
; PURPOSE:
;    Estimate the background of a holographic video sequence
;    with a running median filter.
;
; CATEGORY:
;    Holographic microscopy, video analysis
;
; CALLING SEQUENCE:
;    bg = bgestimate(a)
;
; INPUTS:
;    a: video object of type DGGgrMPlayer.  Must be grayscale.
;
; KEYWORD PARAMETERS:
;    n0: first frame at which to start estimating background
;    n1: last frame from which to estimate background
;
; OUTPUTS:
;    bg: floating-point estimate for the background
;
; SIDE EFFECTS:
;    Reads through the movie, without rewinding.  Can be
;    time-consuming for long movies.
;
; RESTRICTIONS:
;    Assumes that each pixel in the image consists of 8 bits of
;    intensity data.  Other formats are not supported.
;
; PROCEDURE:
;    Estimate median value at each pixel by histogram analysis
;
; EXAMPLE:
; IDL> a = dgggrmplayer('VTS_03_1.VOB', /gray, dim = [640,480])
; IDL> bg = bgestimate(a)
;
; MODIFICATION HISTORY:
; 01/15/2013 Written by David G. Grier, New York University
; 02/03/2013 DGG Minimum value is 1, rather than 0.
;
; Copyright (c) 2013 David G. Grier
;-
function bgestimate, a, n0 = n0, n1 = n1

COMPILE_OPT IDL2

umsg = 'bg = bgestimate(a, n0 = n0, n1 = n1)'

;a = dgggrmplayer('~/Desktop/VTS_03_1.VOB', /gray, dim = [w, h])

if ~isa(a, 'DGGgrMPlayer') then begin
   message, umsg, /inf
   message, 'A must be a DGGgrMPlayer object', /inf
   return, -1
endif

if ~a.greyscale then begin
   message, umsg, /inf
   message, 'A must be a grayscale video object', /inf
   return, -1
endif

if ~isa(n0, /number, /scalar) then $
   n0 = 0L

if isa(n1, /number, /scalar) then begin
   if n1 le n0 then begin
      message, 'n1 must be greater than n0', /inf
      return, -1
   endif
endif

if a.framenumber gt n0 then $
   a.rewind
while a.framenumber lt n0 do begin
   a.readframe
   if a.eof then begin
      message, umsg, /inf
      message, 'n0 exceeds the number of frames in the movie', /inf
      return, -1
   endif
endwhile

dim = a.dimensions
w = dim[0]
h = dim[1]
npts = w * h

b = fltarr(npts, 256) ; histogram
ndx = lindgen(npts)

nframes = 0.
if isa(n1, /number, /scalar) then begin
   while a.framenumber lt n1 and ~a.eof do begin
      b[ndx, a.next]++
      nframes++
   endwhile
   if a.framenumber lt n1 then begin
      message, umsg, /inf
      message, 'n1 exceeds the number of frames in the movie', /inf
      return, -1
   endif
endif else begin
   while ~a.eof do begin
      b[ndx, a.next]++
      nframes++
   endwhile
endelse 

b = total(b, 2, /cumulative) - nframes/2.
m = min(b, med, /absolute, dim = 2)
med = float(med)/npts > 1
return, reform(med, w, h)
end
