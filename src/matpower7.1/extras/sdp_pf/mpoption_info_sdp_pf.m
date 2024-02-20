function opt = mpoption_info_sdp_pf(selector)
%MPOPTION_INFO_SDP_PF  Returns MATPOWER option info for SDP_PF.
%
%   DEFAULT_OPTS = MPOPTION_INFO_SDP_PF('D')
%   VALID_OPTS   = MPOPTION_INFO_SDP_PF('V')
%   EXCEPTIONS   = MPOPTION_INFO_SDP_PF('E')
%
%   Returns a structure for SDP_PF options for MATPOWER containing ...
%   (1) default options,
%   (2) valid options, or
%   (3) NESTED_STRUCT_COPY exceptions for setting options
%   ... depending on the value of the input argument.
%
%   This function is used by MPOPTION to set default options, check validity
%   of option names or modify option setting/copying behavior for this
%   subset of optional MATPOWER options.
%
%   See also MPOPTION.

%   MATPOWER
%   Copyright (c) 2014-2019, Power Systems Engineering Research Center (PSERC)
%   by Ray Zimmerman, PSERC Cornell
%
%   This file is part of MATPOWER/mx-sdp_pf.
%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See https://github.com/MATPOWER/mx-sdp_pf/ for more info.

if nargin < 1
    selector = 'D';
end
if have_feature('sdp_pf')
    switch upper(selector)
        case {'D', 'V'}     %% default and valid options
            opt = struct(...
                'sdp_pf',   struct(...
                    'max_number_of_cliques',    0.1, ...
                    'eps_r',                    1e-4, ...
                    'recover_voltage',          4, ...
                    'recover_injections',       2, ...
                    'min_Pgen_diff',            1, ...
                    'min_Qgen_diff',            1, ...
                    'max_line_limit',           9900, ...
                    'max_gen_limit',            99998, ...
                    'ndisplay',                 100, ...
                    'choldense',                10, ...
                    'cholaggressive',           1, ...
                    'bind_lagrange',            1e-3, ...
                    'zeroeval_tol',             1e-4, ...
                    'mineigratio_tol',          1e5, ...
                    'opts',                     [], ...
                    'opt_fname',                '' ...
                ) ...
            );
        case 'E'            %% exceptions used by nested_struct_copy() for applying
            opt = struct([]);   %% no exceptions
        otherwise
            error('mpoption_info_sdp_pf: ''%s'' is not a valid input argument', selector);
    end
else
    opt = struct([]);       %% SDP_PF is not available
end
