function [res, top_speed] = find_optimal_fuel(num_stages)

    cost_per_kg = 5500;
    fuel_price = 2.72;
    cost_per_stage = 500e3;
    flow_rate = 122; % rate of fuel consumption kg/s
    v_exhaust = 3000; %exhaust velocity in m/s
    payload = 1000; % the weight of the payload
    max_weight = (flow_rate * v_exhaust / 9.81 - payload) / 5;
    
    x0 = ones(num_stages, 1) * max_weight / 4 * 1.25; % this is our initial guess

    function res = optimize_cost(mstages)
        res = cost_per_kg*(5*sum(mstages) + payload) + fuel_price * ...
            sum(mstages)*4 + cost_per_stage*length(mstages);
    end

    lb = ones(num_stages, 1) * 20;
    ub = [];
    A = ones(1, num_stages);
    b = max_weight;
    Aeq = [];
    Beq = [];
    
    res = fmincon(@optimize_cost, x0, A, b, Aeq, Beq, lb, ub, ...
        @get_top_speed);
    
    top_speed = get_top_speed(res);

end