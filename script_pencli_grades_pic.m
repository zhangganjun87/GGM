pencil_grades = {'9H', '8H', '7H', '6H', '5H', '4H', '3H', '2H', 'H', 'F', 'HB', 'B', '2B', '3B', '4B', '5B', '6B', '7B', '8B', '9B'};
gray_levels =    [221, 204,  199,  187,  183,  170,  153,  136,  119, 102,  85,  74,  68,   58,   51,   42,   34,   26,   17,   0];
figure;
scatter(1:length(gray_levels), gray_levels, 80, 'r', 'Marker', '*', 'MarkerEdgeColor', 'r', 'LineWidth', 1.0); % 红色星号标记
hold on;
xticks(1:length(pencil_grades));
xticklabels(pencil_grades);
xlabel('Pencil Grade', 'FontSize', 18);
ylabel('Gray Level', 'FontSize', 18);
legend({'Gray Level of Pencil Grades', 'Fitted Benchmark Curve'}, 'Location', 'best', 'FontSize', 16);
xlim([0 length(gray_levels) + 1]);
ylim([-10 260]);
grid on;
hold off;