function y = sa(s, a)
y= exp(-a*s)./((1+exp(-a*s)).^2);
end