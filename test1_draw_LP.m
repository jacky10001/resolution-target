
% unit: mm

dx = 0.1 ;

target = zeros(483,700) ;

cnt_draw = 0 ;
for tG=-2
    next_space = 0 ;
    for tE=1:6
        width = compute_width(tG,tE) ;
        tw_start = 1 ;
        tl_start = 1 ;
        tw_range = round(width/dx) ;
        tl_range = tw_range * 5 ;
        
        if mod(cnt_draw,2) == 0 && tE == 1 
            
        else
            target = draw_LP(target, ...
                tw_start,tw_range, ...
                tl_start,tl_range, ...
                next_space);

            next_space = next_space + 2*tw_range + tl_range ;  % 線對極及線對的間隔 (Y軸)
        end
    end
    cnt_draw = cnt_draw + 1 ;
end

figure(1),imagesc(target),colormap gray,axis image


function val = compute_width(tG,tE)
val = 2^(tG+(tE-1)/6) ;
val = 1/2/val ;
end

function target = draw_LP(target,tw_start,tw_range,tl_start,tl_range,next_space)
    tw_start = tw_start + next_space ;
    for i=1:5
        if mod(i,2) == 1
            for dd = tw_start:tw_start+tw_range
                target(dd,tl_start:tl_range) = 1 ;
            end
        end
        tw_start = tw_start + tw_range ;
    end
    tw_start = tl_range + 2*tw_range ;  % 一組線對間隔 (X軸)
    for i=6:10
        if mod(i,2) == 0
            for dd = tw_start:tw_start+tw_range
                target(tl_start+next_space:tl_range+next_space,dd) = 1 ;
            end
        end
        tw_start = tw_start + tw_range ;
    end
end