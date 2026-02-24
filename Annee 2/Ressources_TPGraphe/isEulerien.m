function result = isEulerien(A)

    boolcon = true;
    booleul = true;

    if not(sum(sum(graphPower(A, (size(A, 1) - 1)))) == (size(A, 1))^2)
        boolcon = false;
        disp("Connexe : " + boolcon);
    else
        disp("Connexe : " + boolcon);
    end

    if not (sum(mod(sum(A), 2)) == 0 || sum(mod(sum(A), 2)) == 2)
        booleul = false;
        disp("Eulerien : " + booleul);
    else
        disp("Eulerien : " + booleul)
    end

    if (boolcon == 1 && booleul == 1)
        result = true;
    else
        result = false;
    end
end