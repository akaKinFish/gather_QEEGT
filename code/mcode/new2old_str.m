function M = new2old_str(M)

    for k = 1:size(M, 3)
        temp = M(:, :, k);
        temp = triu(temp)' - tril(temp, -1)';
        M(:, :, k) = temp;
    end

end
