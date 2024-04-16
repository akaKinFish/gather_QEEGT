function result = existsf(nfile);
    fid = fopen(nfile, 'r');

    if fid == -1,
        result = 0;
    else
        result = 1;
        fclose(fid);
    end

    %#realonly
    %#inbounds

end
