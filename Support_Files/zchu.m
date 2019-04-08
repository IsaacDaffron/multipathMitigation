function du = zchu(N, rI)
    % Creates an N-length zadoff chu sequence based on 
    % [1] Chu, D. C. “Polyphase codes with good periodic correlation properties.” 
    % IEEE Trans. Inf. Theory. Vol. 18, Number 4, July 1972, pp. 531–532.
    
    
    assert(mod(N,2) == 0, 'N must be even');
    
    du = zeros(N,1);
    
    for n = 0:(N/2)-1
       du(n+1) = exp((-1i*pi*rI*n*(n+1))/(N+1));
    end
    
    for n = (N/2):N-1
       du(n+1) = exp((-1i*pi*rI*(n+1)*(n+2))/(N+1)); 
    end
end
