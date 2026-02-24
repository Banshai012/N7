function result = possedechaine(A, c)
    bool = true;
    for i=1:(size(c, 2) - 1)  
        if(A(c(i), c(i + 1)) == 0)
            A(c(i), c(i + 1));
            bool = false;
        end
    end
    if (bool == 1)
        result = true;
    else
        result = false;
    end
end