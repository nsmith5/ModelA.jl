module modelA

export model, parameters, step!

const kb = 1.0                # Boltzmann Constant


type model
    # ------------------------------------
    #  Set of thermodynamic parameters
    # ------------------------------------
    W0::Float64   # Laplacian coefficient
    a2::Float64   # Second order field coefficient
    a4::Float64   # Fourth order field coefficient
    M ::Float64   # Mobility
    T::Float64    # Temperature
end


type parameters
  	# ---------------------------
  	#   Physical parameters
  	# ---------------------------
  	dx::Float64   # Size of the space step
  	dt::Float64   # Size of the time step
end


function ∇²(ϕ, prmtr::parameters)
	N = size(ϕ)[1]
  	dx = prmtr.dx
  	temp = zeros(N,N)
	  
	for i in 2:(N-1)
    	for j in 2:(N-1)
      		temp[i,j] = (ϕ[i+1,j] - 2 * ϕ[i,j] + ϕ[i - 1, j])/dx^2 + 
                (ϕ[i,j+1]-2ϕ[i,j]+ϕ[i,j-1]) /dx^2
    	end
  	end
	  
	for i in 1:N
		temp[i,N] = (ϕ[mod1(i+1,N), N] - 2 * ϕ[mod1(i,N), N] + ϕ[mod1(i-1,N), N] ) / dx ^ 2 +
			(ϕ[mod1(i,N), 1] - 2 * ϕ[mod1(i,N), N] + ϕ[mod1(i,N), N-1]) / dx ^ 2
		temp[i,1] = (ϕ[mod1(i+1, N), 1] - 2 * ϕ[mod1(i, N), 1] + ϕ[mod1(i-1, N), 1]) / dx ^ 2 +
			(ϕ[mod1(i, N),2] - 2 * ϕ[mod1(i, N), 1] + ϕ[mod1(i, N), N]) / dx ^ 2
  	end
	  
	for j in 1:N
    	temp[N,j] =(ϕ[ N, mod1(j+1,N)] -2*ϕ[ N, mod1(j,N)]+ϕ[N, mod1(j-1,N)])/dx^2+
                   (ϕ[1, mod1(j,N)] -2*ϕ[ N, mod1(j,N)]+ϕ[N-1, mod1(j,N)])/dx^2
    	temp[1,j] =(ϕ[1,mod1(j+1,N)]-2*ϕ[1,mod1(j,N)]+ϕ[1, mod1(j-1,N)])/dx^2 +
                   (ϕ[2, mod1(j,N)]-2*ϕ[1,mod1(j,N)]+ϕ[N, mod1(j,N)]) /dx^2
  	end

  	return temp
end


function step!(ϕ, mod::model, prmtr::parameters)
    # ----------------------
    #   Euler time march
    # the field by one time
    # step.
    # ----------------------
    N = size(ϕ)[1]            # Size of the field

    ζ = sqrt(2*mod.M*kb*mod.T)*randn(N,N)   # Generate noise
    ∇²ϕ = ∇²(ϕ, prmtr) 
   
    ϕ .+= prmtr.dt * (mod.M * (mod.W0 * ∇²ϕ .- mod.a2 * ϕ .- mod.a4 * ϕ.^3) .+ ζ)         # Update the field phi
    return ϕ
end

end
