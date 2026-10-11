/** 组队信息
 */
declare interface ProtoFmtInfo {
    24000: {
        desc: "创建队伍";
        send: (
            number: 24000,
            fmt: "ccihhi",
            args: [
                /**活动大类id*/
                activity_id: number,
                /**活动子类id*/
                subtype: number,
                /**场景id*/
                scene_id: number,
                /**最低等级*/
                min_lv: number,
                /**最高等级*/
                max_lv: number,
                /**入队条件参数*/
                join_con_value: number
            ]
        ) => never;
        sendFmt: "ccihhi";
        sendArgs: [
            /**活动大类id*/
            activity_id: number,
            /**活动子类id*/
            subtype: number,
            /**场景id*/
            scene_id: number,
            /**最低等级*/
            min_lv: number,
            /**最高等级*/
            max_lv: number,
            /**入队条件参数*/
            join_con_value: number
        ];
        recv: {
            /** 错误码 */
            res: number;
            /**  错误码参数 */
            error_code_args: string;
        };
    };
    24002: {
        desc: "申请入队（招募面板）未能获得队伍id的请看24016";
        send: (
            number: 24002,
            fmt: "lcc",
            args: [
                /**队伍id(从24012获得)*/
                team_id: number,
                activity_id: number,
                subtype: number
            ]
        ) => never;
        sendFmt: "lcc";
        sendArgs: [
            /**队伍id(从24012获得)*/
            team_id: number,
            activity_id: number,
            subtype: number
        ];
        recv: {
            /** 错误码 */
            res: number;
            /**  错误码参数 */
            error_code_args: string;
        };
    };
    24003: {
        desc: "队长收到申请入队";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 服id */
            server_id: number;
            /** 玩家id */
            player_id: number;
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
    24004: {
        desc: "队长回应加入队伍请求";
        send: (number: 24004, fmt: any, args: [res_request: any]) => never;
        sendFmt: any;
        sendArgs: [res_request: any];
        recv: {
            /** 错误码 */
            res: number;
        };
    };
    24005: {
        desc: "离开队伍";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            res: number;
        };
    };
    24006: {
        desc: "邀请别人加入队伍";
        send: (
            number: 24006,
            fmt: "ccihhA",
            args: [
                /**活动大类id*/
                activity_id: number,
                /**活动子类id*/
                subtype: number,
                /**场景id*/
                scene_id: number,
                /**最低等级*/
                min_lv: number,
                /**最高等级*/
                max_lv: number,
                invite_list: any
            ]
        ) => never;
        sendFmt: "ccihhA";
        sendArgs: [
            /**活动大类id*/
            activity_id: number,
            /**活动子类id*/
            subtype: number,
            /**场景id*/
            scene_id: number,
            /**最低等级*/
            min_lv: number,
            /**最高等级*/
            max_lv: number,
            invite_list: any
        ];
        recv: {
            /** 错误码 */
            res: number;
        };
    };
    24007: {
        desc: "邀请加入队伍信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 队伍id */
            team_id: number;
            /** 队伍人数 */
            num: number;
            /** 活动大类id */
            activity_id: number;
            /** 活动子类id */
            subtype: number;
            /** 场景id */
            scene_id: number;
            /** 邀请者id */
            inviter_id: number;
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
            /** 邀请者场景ID */
            invite_scene_id: number;
            /** 邀请类型 0普通，1退出副本后再次邀请 */
            invite_type: number;
        };
    };
    24008: {
        desc: "被邀请者回应消息";
        send: (number: 24008, fmt: any, args: [response_list: any]) => never;
        sendFmt: any;
        sendArgs: [response_list: any];
        recv: {
            /** 错误码 */
            res: number;
            /**  错误码参数 */
            error_code_args: string;
        };
    };
    24009: {
        desc: "踢出队伍";
        send: (
            number: 24009,
            fmt: "l",
            args: [
                /**踢出者id*/
                kick_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**踢出者id*/
            kick_id: number
        ];
        recv: {
            /** 错误码 */
            res: number;
        };
    };
    24010: {
        desc: "队伍信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            team_id: number;
            /** 活动大类id */
            activity_id: number;
            /** 活动子类id */
            subtype: number;
            /** 场景id */
            scene_id: number;
            /** 1首次满4人 0未满4人 */
            pre_num_full: number;
            /** 自动匹配状态 1正在匹配中 0不在匹配中 (队长需要知道，其它队员暂时不需) */
            auto_matching: number;
            /** 匹配开始时间(状态处于匹配中才有效) */
            match_st: number;
            /** 等级下限 */
            min_lv: number;
            /** 等级上限 */
            max_lv: number;
            /** 入队条件参数(与活动大类子类有关) */
            join_con_value: number;
            /** 人满后是否自动开始 0 不自动开始 1自动开始 */
            auto_start: number;
            /** 队员加入类型##1:不自动，要队长审核2:自动同意进入队伍 */
            join_type: number;
            team_member_list: {
                /** 队员id */
                id: number;
                /** 1为队长，2为队员 3假人 */
                team_position: number;
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
                /** 助战类型 */
                help_type: number;
                /** 队员当前的场景id */
                scene_id: number;
                /** 加入时间戳 */
                join_time: number;
                /** 战斗力 */
                power: number;
                /** 是否在线 */
                online: number;
                /** 服id */
                server_id: number;
                /** 服数 */
                server_num: number;
                /** 玩家的活动入队参数 */
                join_value: number;
            }[];
        };
    };
    24011: {
        desc: "委任队长";
        send: (
            number: 24011,
            fmt: "l",
            args: [
                /**新队长id*/
                new_leaderid: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**新队长id*/
            new_leaderid: number
        ];
        recv: {
            /** 错误码 */
            res: number;
        };
    };
    24012: {
        desc: "查看队伍招募面板";
        send: (
            number: 24012,
            fmt: "cci",
            args: [
                /**活动大类id*/
                activity_id: number,
                /**活动子类id*/
                subtype: number,
                /**场景id*/
                scene_id: number
            ]
        ) => never;
        sendFmt: "cci";
        sendArgs: [
            /**活动大类id*/
            activity_id: number,
            /**活动子类id*/
            subtype: number,
            /**场景id*/
            scene_id: number
        ];
        recv: {
            /** 活动大类id */
            activity_id: number;
            /** 活动子类id */
            subtype: number;
            /** 场景id */
            scene_id: number;
            team_enlist: {
                /** 队伍id */
                team_id: number;
                /** 队伍人数 */
                num: number;
                /** 入队条件参数 */
                join_con_value: number;
                members: {
                    /** 队员id */
                    id: number;
                    /** 1为队长，2为队员 3假人 */
                    team_position: number;
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
                    /** 助战类型 */
                    help_type: number;
                    /** 队员当前的场景id */
                    scene_id: number;
                    /** 是否在线 */
                    online: number;
                    /** 服id */
                    server_id: number;
                    /** 服数 */
                    server_num: number;
                    /** 玩家的活动入队参数 */
                    join_value: number;
                    /** 战力 */
                    power: number;
                }[];
            }[];
        };
    };
    24013: {
        desc: "广播场景中玩家的组队属性";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            id: number;
            /** 队伍id(0无队伍) */
            team_id: number;
            /** (0无，1队长，2队员) */
            position: number;
        };
    };
    24014: {
        desc: "离开队员信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 离开的队员id(如果id等于自己，则自己被踢出) */
            id: number;
        };
    };
    24015: {
        desc: "队长变更信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 新队长id */
            id: number;
        };
    };
    24016: {
        desc: "申请入队（点击玩家）";
        send: (
            number: 24016,
            fmt: "l",
            args: [
                /**玩家id*/
                player_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**玩家id*/
            player_id: number
        ];
        recv: {
            /** 错误码 */
            res: number;
        };
    };
    24017: {
        desc: "更改组队目标";
        send: (
            number: 24017,
            fmt: "ccihhi",
            args: [
                /**活动大类id*/
                activity_id: number,
                /**活动子类id*/
                subtype: number,
                /**场景id*/
                scene_id: number,
                /**最低等级*/
                min_lv: number,
                /**最高等级*/
                max_lv: number,
                /**活动入队条件*/
                join_con_value: number
            ]
        ) => never;
        sendFmt: "ccihhi";
        sendArgs: [
            /**活动大类id*/
            activity_id: number,
            /**活动子类id*/
            subtype: number,
            /**场景id*/
            scene_id: number,
            /**最低等级*/
            min_lv: number,
            /**最高等级*/
            max_lv: number,
            /**活动入队条件*/
            join_con_value: number
        ];
        recv: {
            /** 错误码 */
            res: number;
            /** 活动大类id */
            activity_id: number;
            /** 活动子类id */
            subtype: number;
            /** 场景id */
            scene_id: number;
            /** 最低等级 */
            min_lv: number;
            /** 最高等级 */
            max_lv: number;
            /** 活动入队条件 */
            join_con_value: number;
        };
    };
    24018: {
        desc: "更改申请自动进入类型";
        send: (
            number: 24018,
            fmt: "c",
            args: [
                /**1:不自动 2:自动同意*/
                join_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1:不自动 2:自动同意*/
            join_type: number
        ];
        recv: {
            /** 错误码 */
            res: number;
            /** 1:不自动 2:自动同意 */
            join_type: number;
        };
    };
    24020: {
        desc: "发起投票";
        send: (
            number: 24020,
            fmt: "ic",
            args: [
                /**活动大类id*/
                activity_id: number,
                /**活动子类id*/
                subtype: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**活动大类id*/
            activity_id: number,
            /**活动子类id*/
            subtype: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /**  错误码参数 */
            error_code_args: string;
            /** 活动大类id */
            activity_id: number;
            /** 活动子类id */
            subtype: number;
            /** 场景id */
            scene_id: number;
            /** 仲裁id */
            arbitrate_id: number;
        };
    };
    24021: {
        desc: "队员投票";
        send: (
            number: 24021,
            fmt: "hc",
            args: [
                /**仲裁id（通过24020获得）*/
                arbitrate_id: number,
                /**(0:反对 1:赞同)*/
                res: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**仲裁id（通过24020获得）*/
            arbitrate_id: number,
            /**(0:反对 1:赞同)*/
            res: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /**  错误码参数 */
            error_code_args: string;
            /** (0:反对 1:赞同) */
            res: number;
        };
    };
    24022: {
        desc: "匹配队伍活动列表次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            ac_list: {
                /** 活动大类id */
                activity_id: number;
                /** 活动子类id */
                subtype: number;
                /** 场景id */
                scene_id: number;
                /** 活动最大次数 0为无次数限制 */
                max: number;
                /** 活动现在次数 */
                now: number;
            }[];
        };
    };
    24023: {
        desc: "匹配队伍列表";
        send: (
            number: 24023,
            fmt: "cc",
            args: [
                /**活动大类id*/
                activity_id: number,
                /**活动子类id*/
                subtype: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**活动大类id*/
            activity_id: number,
            /**活动子类id*/
            subtype: number
        ];
        recv: {
            /** 错误码 */
            res: number;
            /** 活动大类id */
            activity_id: number;
            /** 活动子类id */
            subtype: number;
        };
    };
    24024: {
        desc: "跟战（会返回24025）";
        send: (
            number: 24024,
            fmt: "cl",
            args: [
                /**(0取消跟战，1开始跟战)*/
                type: number,
                /**(type=1时，跟战目标玩家id)*/
                follow_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**(0取消跟战，1开始跟战)*/
            type: number,
            /**(type=1时，跟战目标玩家id)*/
            follow_id: number
        ];
        recv: {
            /** 错误码 */
            res: number;
            /** (type=1时，跟战目标玩家id) */
            follow_id: number;
        };
    };
    24025: {
        desc: "目标位置信息";
        send: (
            number: 24025,
            fmt: "l",
            args: [
                /**目标玩家id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**目标玩家id*/
            id: number
        ];
        recv: {
            /** 目标玩家id */
            id: number;
            /** 场景id */
            scene: number;
            x: number;
            y: number;
            /** 是否跟战 */
            is_follow: number;
            /** 英灵殿PkId */
            valhalla_pk_id: number;
        };
    };
    24026: {
        desc: "查询跟战状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 跟随的队员id（大于0为跟战） */
            follow_id: number;
        };
    };
    24030: {
        desc: "组队提示语";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            res: number;
        };
    };
    24032: {
        desc: "批量查看队伍人数";
        send: (number: 24032, fmt: any, args: [team_ids: any]) => never;
        sendFmt: any;
        sendArgs: [team_ids: any];
        recv: {
            team_nums: {
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
                /** 队伍id */
                team_id: number;
                /** 队伍人数 */
                team_num: number;
                /** 活动大类id */
                activity_id: number;
                /** 活动子类id */
                subtype: number;
            }[];
        };
    };
    24033: {
        desc: "助战";
        send: (
            number: 24033,
            fmt: "ic",
            args: [
                /**副本id*/
                dun_id: number,
                /**助战类型(0:无;1:助战)*/
                help_type: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**副本id*/
            dun_id: number,
            /**助战类型(0:无;1:助战)*/
            help_type: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 副本id */
            dun_id: number;
            /** 助战类型(0:无;1:助战) */
            help_type: number;
        };
    };
    24034: {
        desc: "广播助战";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            help_type_list: {
                /** 队员id */
                role_id: number;
                /** 助战类型 */
                help_type: number;
            }[];
        };
    };
    24035: {
        desc: "广播发起投票";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动大类id */
            activity_id: number;
            /** 活动子类id */
            subtype: number;
            /** 场景id */
            scene_id: number;
            /** 仲裁id */
            arbitrate_id: number;
            /** 结束时间戳 */
            end_time: number;
        };
    };
    24036: {
        desc: "广播队员投票";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 仲裁id */
            arbitrate_id: number;
            /** (0:反对 1:赞同) */
            res: number;
        };
    };
    24037: {
        desc: "广播投票结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
            /**  错误码参数 */
            error_code_args: string;
        };
    };
    24038: {
        desc: "带参数队伍提示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
            /**  错误码参数 */
            error_code_args: string;
        };
    };
    24039: {
        desc: "取消别人跟战";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    24040: {
        desc: "取消仲裁";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    24041: {
        desc: "队伍成员自动寻路到目标点注：跟战状态的队员不用处理";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 场景id */
            scene_id: number;
            /** x坐标 */
            x: number;
            /** y坐标 */
            y: number;
        };
    };
    24042: {
        desc: "获取剩余次数";
        send: (
            number: 24042,
            fmt: "c",
            args: [
                /**活动大类id*/
                activity_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**活动大类id*/
            activity_id: number
        ];
        recv: {
            /** 1为正常；2为不限 */
            type: number;
            /** 剩余次数， */
            left_time: number;
        };
    };
    24043: {
        desc: "广播进入野外修炼";
        send: (
            number: 24043,
            fmt: "iihh",
            args: [
                /**场景id*/
                scene_id: number,
                /**怪物id*/
                mon_id: number,
                /**x坐标*/
                x: number,
                /**y坐标*/
                y: number
            ]
        ) => never;
        sendFmt: "iihh";
        sendArgs: [
            /**场景id*/
            scene_id: number,
            /**怪物id*/
            mon_id: number,
            /**x坐标*/
            x: number,
            /**y坐标*/
            y: number
        ];
        recv: {
            /** 场景id */
            scene_id: number;
            /** 怪物id */
            mon_id: number;
            /** x坐标 */
            x: number;
            /** y坐标 */
            y: number;
        };
    };
    24044: {
        desc: "附近队伍匹配";
        send: (number: 24044, fmt: any, args: [team_ids: any]) => never;
        sendFmt: any;
        sendArgs: [team_ids: any];
        recv: {
            /** 错误码 */
            res: number;
        };
    };
    24045: {
        desc: "召集队友";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            res: number;
        };
    };
    24046: {
        desc: "广播召集";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 队长id */
            role_id: number;
            /** 结束时间戳 */
            end_time: number;
        };
    };
    24047: {
        desc: "查询申请列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reqlist: {
                /** 服id */
                server_id: number;
                /** 玩家id */
                player_id: number;
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
                /** 战力 */
                combat_power: number;
                /** 服数 */
                server_num: number;
            }[];
        };
    };
    24048: {
        desc: "设置队伍自动匹配状态";
        send: (number: 24048, fmt: "c", args: [state: number]) => never;
        sendFmt: "c";
        sendArgs: [state: number];
        recv: {
            /** 错误码 */
            res: number;
            /**  错误码参数 */
            error_code_args: string;
            /** 自动匹配状态 1正在匹配中 0不在自动匹配中 2 匹配成功 */
            state: number;
            /** 匹配开始时间(操作成功且状态处于匹配中才有效) */
            match_st: number;
            /** 活动大类id */
            activity_id: number;
            /** 活动子类id */
            subtype: number;
            /** 取消的玩家的id。 res = 1,state = 0, 当前有队伍, role_id不等于0时有意义 */
            role_id: number;
        };
    };
    24049: {
        desc: "获取我的助战状态";
        send: (number: 24049, fmt: "i", args: [dun_id: number]) => never;
        sendFmt: "i";
        sendArgs: [dun_id: number];
        recv: {
            dun_id: number;
            /** 助战状态 1助战 0非助战 */
            state: number;
        };
    };
    24050: {
        desc: "获取我的经验加成";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 经验加成 万分比 */
            exp_scale: number;
        };
    };
    24051: {
        desc: "队员位置发生变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 场景id */
            scene_id: number;
        };
    };
    24052: {
        desc: "队员在线状态发生变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 1在线0离线 */
            online: number;
        };
    };
    24053: {
        desc: "获取附近的玩家pool_id,copy_id取的是玩家当前的如果需要获得多个场景的玩家数据,需要客户端间隔发送";
        send: (
            number: 24053,
            fmt: "i",
            args: [
                /**场景id*/
                scene_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**场景id*/
            scene_id: number
        ];
        recv: {
            /** 场景id */
            scene_id: number;
            users: {
                /** 玩家id */
                role_id: number;
                /**  平台(显示用) */
                platform: string;
                /** 第几服(显示用) */
                serv_num: number;
                /** 服务器Id */
                serv_id: number;
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
    24054: {
        desc: "带着目标匹配";
        send: (
            number: 24054,
            fmt: "cc",
            args: [activity_id: number, subtype: number]
        ) => never;
        sendFmt: "cc";
        sendArgs: [activity_id: number, subtype: number];
        recv: null;
    };
    24055: {
        desc: "喊话";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    24056: {
        desc: "是否继续邀请队员";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            members: {
                server_id: number;
                role_id: number;
            }[];
        };
    };
    24057: {
        desc: "邀请别人加入队伍(带服务器id)";
        send: (number: 24057, fmt: any, args: [invite_list: any]) => never;
        sendFmt: any;
        sendArgs: [invite_list: any];
        recv: {
            /** 错误码 */
            res: number;
        };
    };
    24058: {
        desc: "什么时候开始副本";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 开始的时间戳 用这个减去当前时间就是剩余的秒数 */
            time: number;
        };
    };
    24059: {
        desc: "人满自动开始";
        send: (number: 24059, fmt: "c", args: [auto: number]) => never;
        sendFmt: "c";
        sendArgs: [auto: number];
        recv: {
            auto: number;
        };
    };
    24060: {
        desc: "招募列表";
        send: (
            number: 24060,
            fmt: "ci",
            args: [
                /**1:推荐;2:公会;3:好友*/
                type: number,
                dun_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**1:推荐;2:公会;3:好友*/
            type: number,
            dun_id: number
        ];
        recv: {
            /** 1:推荐;2:公会;3:好友 */
            type: number;
            dun_id: number;
            array_list: {
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
                /** 挑战次数 */
                count: number;
                /** 最大次数 */
                max_count: number;
                /** 战力 */
                combat_power: number;
            }[];
        };
    };
    24061: {
        desc: "队员招募列表无队伍，在线";
        send: (
            number: 24061,
            fmt: "c",
            args: [
                /**2:公会;3:好友*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**2:公会;3:好友*/
            type: number
        ];
        recv: {
            /** 2:公会;3:好友 */
            type: number;
            array_list: {
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
                /** 战力 */
                combat_power: number;
            }[];
        };
    };
    24062: {
        desc: "催促开启活动";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    24063: {
        desc: "一键同意入队";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
}
