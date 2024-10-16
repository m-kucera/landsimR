par(mfrow = c(5, 5))

for (i in 1:5){
  for (j in 1:5){
    f = c(.01, .05, .1, .25, .5)[i]
    q = c(.05, .1, .25, .5, .75)[j]
    set.seed(0)
    m = ambient::noise_simplex(c(100, 100), f) |> classify_noise(q)
    C = count_patches(m)
    #m |> rast() |> plot(main = paste0('f: ', f, '; q: ', q, '; c: ', C), legend = F)



  }
}

# adjustment of draw order:
# for each (not the first) class look at the sum of area and n_patches
# of all classes before and adjust the estimation
  # if not many patches before and class has many -> high f
  # if not many patches before and class has few -> low f
  # if many patches before -> depends on area sum
  # if high area sum before -> make q estimation higher
