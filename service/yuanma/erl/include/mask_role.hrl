
-record(base_mask,{
        id = 0              %%id
        ,goods_id = 0      %%物品id
        ,name = ""
        ,level = 0
        ,duration = 0
    }).

-record(mask_status,{
        mask_id = 0              %%id
        , end_time = 0
        , ref = []
    }).