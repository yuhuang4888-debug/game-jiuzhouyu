/** 九魂圣殿
 */
declare interface ProtoFmtInfo {
    13500: {
        desc: "九魂圣殿状态(状态变更时会推送)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 状态 0未开放 1开放期间 */
            state: number;
            /** 剩余时间 */
            left_time: number;
            /** 分服模式1248 */
            mod: number;
            /** 分区组id */
            group_id: number;
            server_list: {
                server_id: number;
                server_num: number;
                server_name: string;
                world_lv: number;
            }[];
            avg_lv: number;
        };
    };
    13501: {
        desc: "战场日志";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 首个登顶玩家server_num */
            first_server_num: number;
            /**  首个登顶玩家 */
            first_player: string;
            /** 秘宝奖励获取者（倒序排序好） */
            get_list: {
                index: number;
                server_num: number;
                role_name: string;
            }[];
        };
    };
    13502: {
        desc: "参战";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 成功 */
            error_code: number;
        };
    };
    13503: {
        desc: "小面板(状态变更时会推送)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前层 */
            cur_floor: number;
            /** 最大层 */
            max_floor: number;
            /** 结束时间 */
            left_time: number;
            /** 击杀数 */
            kill_num: number;
            /** 积分 */
            score: number;
            /** 登顶玩家server_num */
            first_server_num: number;
            /**  首位登顶玩家 */
            first_player: string;
        };
    };
    13504: {
        desc: "广播秘宝持有者(状态变更时会推送)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            index: number;
            server_num: number;
            /** 玩家ID，为0的话就清除当前的持有者 */
            role_id: number;
            /**  持有者名字 */
            role_name: string;
            /** 结束时间 */
            left_time: number;
        };
    };
    13505: {
        desc: "离开";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    13506: {
        desc: "复活";
        send: (
            number: 13506,
            fmt: "c",
            args: [
                /**复活类型*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**复活类型*/
            type: number
        ];
        recv: null;
    };
    13507: {
        desc: "结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            max_floor: number;
            reward: any;
            /** 首个登顶玩家server_num */
            first_server_num: number;
            /**  首个登顶玩家 */
            first_player: string;
            /** 秘宝奖励获取者（倒序排序好） */
            get_list: {
                index: number;
                server_num: number;
                role_name: string;
            }[];
        };
    };
    13508: {
        desc: "积分";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 增加的积分 */
            score: number;
            /** 总积分 */
            total_score: number;
        };
    };
    13509: {
        desc: "连杀";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
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
            /** 当前连杀 */
            dkill: number;
        };
    };
    13510: {
        desc: "持有者figure信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
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
        };
    };
}
