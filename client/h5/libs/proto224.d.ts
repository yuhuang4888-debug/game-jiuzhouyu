/** 魅力结婚榜活动信息
 */
declare interface ProtoFmtInfo {
    22400: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    22401: {
        desc: "活动榜单信息";
        send: (
            number: 22401,
            fmt: "ih",
            args: [
                /**请求的排行榜类型 :351 男生鲜花榜 352 女生鲜花榜*/
                type: number,
                /**活动子类*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "ih";
        sendArgs: [
            /**请求的排行榜类型 :351 男生鲜花榜 352 女生鲜花榜*/
            type: number,
            /**活动子类*/
            sub_type: number
        ];
        recv: {
            rank_type: number;
            /** 请求者排行 0为未上榜 */
            sel_rank: number;
            /** 自己的值 */
            sel_val: number;
            /** 排行榜总人数 */
            sum: number;
            /** 最大长度 */
            max_len: number;
            /** 上榜阈值 */
            rank_limit: number;
            rank_list: {
                player_id: number;
                name: string;
                sex: number;
                career: number;
                vip: number;
                guild_name: string;
                picture: string;
                picture_ver: number;
                turn: number;
                dress_list: {
                    /** 装扮类型（1相框，2气泡） */
                    type: number;
                    /** 装扮id */
                    dress_id: number;
                }[];
                /** 值  对应排行榜的相应的值，魅力值 */
                first_value: number;
                rank: number;
            }[];
        };
    };
    22402: {
        desc: "结婚榜单信息";
        send: (
            number: 22402,
            fmt: "ih",
            args: [
                /**请求的排行榜类型 :360 结婚榜*/
                type: number,
                sub_type: number
            ]
        ) => never;
        sendFmt: "ih";
        sendArgs: [
            /**请求的排行榜类型 :360 结婚榜*/
            type: number,
            sub_type: number
        ];
        recv: {
            rank_type: number;
            /** 排行榜总人数 */
            sum: number;
            max_len: number;
            /** 婚礼价格折扣 */
            discount: number;
            rank_list: {
                role_id: number;
                name: string;
                sex: number;
                career: number;
                vip: number;
                /**  玩家上传的头像地址 */
                picture: string;
                /** 玩家上传的头像版本号 */
                picture_ver: number;
                turn: number;
                dress_list: {
                    /** 装扮类型（1气泡，2相框） */
                    type: number;
                    /** 装扮id */
                    dress_id: number;
                }[];
                sec_id: number;
                sec_name: string;
                sec_sex: number;
                sec_career: number;
                sec_vip: number;
                sec_picture: string;
                sec_picture_ver: number;
                sec_turn: number;
                sec_dress_list: {
                    /** 装扮类型（1相框，2气泡） */
                    type: number;
                    /** 装扮id */
                    dress_id: number;
                }[];
                /** 值  对应排行榜的相应的值， */
                first_value: number;
                /** 值（保留）  婚礼类型  0无 1下 2中 3上 */
                second_value: number;
                /** 婚礼类型奖励倍数 */
                reward_times: number;
                rank: number;
            }[];
        };
    };
    22403: {
        desc: "跨服鲜花榜信息";
        send: (
            number: 22403,
            fmt: "ih",
            args: [
                /**请求的排行榜类型 :371男榜 372女榜*/
                type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "ih";
        sendArgs: [
            /**请求的排行榜类型 :371男榜 372女榜*/
            type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 请求的排行榜类型 :371男榜 372女榜 */
            type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 请求者排行 0为未上榜 */
            sel_rank: number;
            /** 自己的值 */
            sel_val: number;
            /** 自己的区域id */
            sel_zone: number;
            /** 排行榜总人数 */
            sum: number;
            /** 最大长度 */
            max_len: number;
            /** 上榜阈值 */
            rank_limit: number;
            rank_list: {
                /** 玩家id */
                role_id: number;
                /** 服务器id */
                server_id: number;
                /** 区域id */
                zone: number;
                /** 所在服标示 */
                server_num: number;
                /**  名字 */
                name: string;
                /** 值  对应排行榜的相应的值，魅力值 */
                first_value: number;
                /** 名次 */
                rank: number;
            }[];
            /** 前三名玩家的figure信息 */
            figure_list: {
                /** 玩家id */
                role_id: number;
                /** 玩家名字 */
                name: string;
                /** 性别 */
                sex: number;
                /** 阵营 */
                realm: number;
                /** 职业 */
                career: number;
                /** 等级 */
                level: number;
                /** 是否GM */
                GM: number;
                /** VIP */
                vip_flag: number;
                /** 职称 */
                touxian: number;
                /** 等级模型 */
                level_model_list: {
                    /** 部位 */
                    part_pos: number;
                    /** 模型id */
                    level_model_id: number;
                }[];
                /** 时装模型 */
                fashion_model_list: {
                    /** 部位 */
                    part_pos: number;
                    /** 模型id */
                    fashion_model_id: number;
                    figure_chartlet_id: number;
                }[];
                /** 自定义头像url */
                picture: string;
                /** 自定义头像版本号 */
                prcture_ver: number;
                /** 帮派id */
                guild_id: number;
                /** 帮派名字 */
                guild_name: string;
                /** 帮派职位 */
                position: number;
                /** 帮派职位名字 */
                position_name: string;
                /** 称号 */
                dsgt_id: number;
                /** 活跃度形象Id */
                image_id: number;
                /** 转生次数 */
                turn: number;
                /** 转生阶段 */
                turn_stage: number;
                /** 爵位等级 */
                grade_id: number;
                /** 结婚状态 0单身 1情侣 2结婚 */
                is_marriage: number;
                /** 伴侣玩家id */
                marriage_id: number;
                /** 伴侣玩家name */
                marriage_name: string;
                /** 护送天使id */
                escort_state: number;
                /** 房子街区id */
                block_id: number;
                /** 房子id */
                house_id: number;
                /** 房子等级 */
                house_lv: number;
                /** 幻化模型 */
                figure_list: {
                    /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                    figure_type: number;
                    /** 模型id */
                    figure_id: number;
                    figure_chartlet_id: number;
                }[];
                /** 幻化模型是否骑乘##找不到数据就默认骑乘 */
                figure_ride_list: {
                    /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                    figure_type: number;
                    /** 是否骑乘(用于场景表现,点击头像等等忽略本字段) */
                    is_ride: number;
                }[];
                /** 成就等级 */
                achv_lv: number;
                /** 勋章id */
                medal_id: number;
                /** 法阵id */
                fazhen_id: number;
                /** 装扮列表 */
                dress_list: {
                    /** 装扮类型 */
                    dress_type: number;
                    /** 装扮id */
                    dress_id: number;
                }[];
                /** 将神id */
                god_id: number;
                /** 天启套装 */
                revelation_suit: number;
                /** 使魔id */
                demon_id: number;
                /** 是否有至尊vip标识 */
                supreme_vip: number;
                /** 头衔id */
                title_id: number;
                /** 蒙面id */
                mask_id: number;
                /** 阵营四海争霸(玩家阵营) */
                seaCamp: number;
                /** 海战日常砖块品质 */
                brick_id: number;
                /** 假人类型（0:玩家） */
                dummy_type: number;
                /** 套装贴图id */
                suit_fashion_id: number;
                /** 采集状态 （0：非采集， 1：采集中） */
                collect_state: number;
            }[];
        };
    };
    22405: {
        desc: "活动榜单信息figure";
        send: (
            number: 22405,
            fmt: "hh",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类*/
            sub_type: number
        ];
        recv: {
            code: number;
            /** 活动类型 */
            type: number;
            /** 活动子类 */
            sub_type: number;
            rank_type: number;
            /** 请求者排行 0为未上榜 */
            sel_rank: number;
            /** 自己的值 */
            sel_val: number;
            /** 排行榜总人数 */
            sum: number;
            /** 最大长度 */
            max_len: number;
            /** 上榜阈值 */
            rank_limit: number;
            rank_list: {
                /** 玩家id */
                role_id: number;
                /**  名字 */
                name: string;
                /** 值  对应排行榜的相应的值 */
                first_value: number;
                /** 排名 */
                rank: number;
            }[];
        };
    };
}
