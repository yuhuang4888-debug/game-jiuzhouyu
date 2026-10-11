-define(DEFAULT_SOURCE_NO, 1).  %%  默认渠道编号

-record(base_level_mail, {
    source_no = 0,              %% 渠道编号
    level = 0,
    reward = []
    }).