function mat_C = her2com(mat_H);

    mat_C = triu(real(mat_H)) - tril(imag(mat_H));
    mat_C = mat_C(:);
end
