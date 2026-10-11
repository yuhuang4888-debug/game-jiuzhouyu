/** 物品信息
 */
declare interface ProtoFmtInfo {
    15000: {
        desc: "获取物品详细信息";
        send: (
            number: 15000,
            fmt: "l",
            args: [
                /**物品Id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**物品Id*/
            goods_id: number
        ];
        recv: {
            /** 物品Id */
            goods_id: number;
            /** 物品类型Id */
            type_id: number;
            /** 物品子位置 */
            sub_pos: number;
            /** 物品格子位置 */
            cell: number;
            /** 物品数量 */
            num: number;
            /** 绑定状态  (0非绑，1绑定) */
            bind: number;
            /** 交易状态  (0不可交易，1可交易) */
            trade: number;
            /** 出售状态  (0不可出售，1可出售) */
            sell: number;
            /** 颜色        (0白色，1绿色，2蓝色，3紫色，4黄色，5橙色，6红色) */
            color: number;
            /** 过期时间戳(0不过期，>0过期时间戳) */
            expire_time: number;
            /** 战斗力 */
            combat_power: number;
            /** 装备类型 */
            equip_type: number;
            /** 价格类型 */
            price_type: number;
            /** 出售价格 */
            sell_price: number;
            /** 强化等级(当前穿在身上的并且部位已经强化过的装备才会有强化等级 其他物品强化等级为0) */
            stren: number;
            /** 强化经验 */
            stren_exp: number;
            /** 装备评分 */
            rating: number;
            /** 装备综合评分 */
            overall_rating: number;
            /** 装备段位 */
            division: number;
            /** 洗炼评分 */
            wash_rating: number;
            /** 附加属性 */
            addition_attrlist: {
                /** 属性类型 */
                attr_type: number;
                /** 属性值 */
                attr_value: number;
                /** 属性颜色 */
                color: number;
                /** 战力 */
                combat_power: number;
            }[];
            /** 宝石列表 */
            stone_list: {
                /** 宝石孔位置 */
                pos: number;
                /** 物品类型Id */
                type_id: number;
            }[];
            /** 附魔列表 */
            magic_list: {
                /** 附魔石物品类型id */
                goods_id: number;
                /** 结束时间戳 */
                end_time: number;
            }[];
            /** 装备附加属性(极品属性) */
            equip_extra_attr: {
                /** 颜色 参考后台颜色配置 */
                color: number;
                /** 类型 1: 成长型属性 2: 普通属性 */
                type_id: number;
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
                /** 每多少级增加(成长型属性使用) */
                plus_interval: number;
                /** 每隔多少级增加多少属性(成长型属性使用) */
                plus_unit: number;
            }[];
            /** 洗炼属性 */
            wash_attr: {
                /** 第几条 */
                index: number;
                /** 颜色 */
                color: number;
                /** 属性id */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
            /** 套装属性 */
            suit_list: {
                /** 套装等级 */
                suit_lv: number;
                /** 第几阶 */
                suit_slv: number;
                /** 目前有几件 */
                suit_count: number;
            }[];
            /** 铸灵阶数 */
            cspirit_stage: number;
            /** 铸灵等级 */
            cspirit_lv: number;
            /** 觉醒等级 */
            awakening_lv: number;
            /** 装备唤魔技能id */
            equip_skill_id: number;
            /** 装备唤魔技能等级 */
            equip_skill_lv: number;
            /** 坐骑装备技能id */
            mount_equip_skill_id: number;
            /** 坐骑装备技能等级 */
            mount_equip_skill_lv: number;
            /** 精灵装备阶数 */
            pet_equip_stage: number;
            /** 精灵装备星数 */
            pet_equip_star: number;
            /** 等级 */
            level: number;
            /** 属性觉醒 */
            awake_list: {
                /** 属性类型 */
                attr_type: number;
                /** 觉醒等级 */
                awake_lv: number;
                /** 经验 */
                awake_exp: number;
            }[];
            /** 神炼升级 */
            refinement_lv: number;
        };
    };
    15001: {
        desc: "查看别人物品详细信息";
        send: (
            number: 15001,
            fmt: "ll",
            args: [
                /**角色Id*/
                player_id: number,
                /**物品Id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "ll";
        sendArgs: [
            /**角色Id*/
            player_id: number,
            /**物品Id*/
            goods_id: number
        ];
        recv: {
            /** 角色Id */
            player_id: number;
            /** 物品Id */
            goods_id: number;
            /** 物品类型Id */
            type_id: number;
            /** 物品子位置 */
            sub_pos: number;
            /** 物品格子位置 */
            cell: number;
            /** 物品数量 */
            num: number;
            /** 绑定状态(0非绑，1绑定) */
            bind: number;
            /** 交易状态(0不可交易，1可交易) */
            trade: number;
            /** 出售状态(0不可出售，1可出售) */
            sell: number;
            /** 颜色(0白色，1绿色，2蓝色，3紫色，4黄色，5橙色，6红色) */
            color: number;
            /** 过期时间戳(0不过期，>0过期时间戳) */
            expire_time: number;
            /** 战斗力 */
            combat_power: number;
            /** 装备类型 */
            equip_type: number;
            /** 价格类型 */
            price_type: number;
            /** 出售价格 */
            sell_price: number;
            /** 强化等级 */
            stren: number;
            /** 装备评分 */
            rating: number;
            /** 装备综合评分 */
            overall_rating: number;
            /** 装备段位 */
            division: number;
            /** 附加属性 */
            addition_attrlist: {
                /** 属性类型 */
                attr_type: number;
                /** 属性值 */
                attr_value: number;
                /** 属性颜色 */
                color: number;
                /** 战力 */
                combat_power: number;
            }[];
            /** 宝石列表 */
            stone_list: {
                /** 宝石孔位置 */
                pos: number;
                /** 物品类型Id */
                type_id: number;
            }[];
            /** 附魔列表 */
            magic_list: {
                /** 附魔石物品类型id */
                goods_id: number;
                /** 结束时间戳 */
                end_time: number;
            }[];
            /** 装备附加属性(极品属性) */
            equip_extra_attr: {
                /** 颜色 参考后台颜色配置 */
                color: number;
                /** 类型 1: 成长型属性  2: 普通属性 */
                type_id: number;
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
                /** 每多少级增加(成长型属性使用) */
                plus_interval: number;
                /** 每隔多少级增加多少属性(成长型属性使用) */
                plus_unit: number;
            }[];
            /** 洗炼属性 */
            wash_attr: {
                /** 第几条 */
                index: number;
                /** 颜色 */
                color: number;
                /** 属性id */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
            /** 洗炼属性 */
            suit_list: {
                /** 套装等级 */
                suit_lv: number;
                /** 第几阶 */
                suit_slv: number;
                /** 目前有几件 */
                suit_count: number;
            }[];
            /** 铸灵阶数 */
            cspirit_stage: number;
            /** 铸灵等级 */
            cspirit_lv: number;
            /** 觉醒等级 */
            awakening_lv: number;
            /** 装备唤魔技能id */
            equip_skill_id: number;
            /** 装备唤魔技能等级 */
            equip_skill_lv: number;
            /** 坐骑装备技能id */
            mount_equip_skill_id: number;
            /** 坐骑装备技能等级 */
            mount_equip_skill_lv: number;
            /** 精灵装备阶数 */
            pet_equip_stage: number;
            /** 精灵装备星数 */
            pet_equip_star: number;
            /** 等级 */
            level: number;
            /** 属性觉醒 */
            awake_list: {
                /** 属性类型 */
                attr_type: number;
                /** 觉醒等级 */
                awake_lv: number;
                /** 经验 */
                awake_exp: number;
            }[];
            /** 神炼升级 */
            refinement_lv: number;
        };
    };
    15002: {
        desc: "玩家开启背包格子";
        send: (
            number: 15002,
            fmt: "hh",
            args: [
                /**格子类型*/
                pos: number,
                /**开启的格子数量*/
                cell_num: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**格子类型*/
            pos: number,
            /**开启的格子数量*/
            cell_num: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 格子类型 */
            pos: number;
            /** 开启的总格子数 */
            cell_num: number;
        };
    };
    15003: {
        desc: "玩家物品转移位置";
        send: (
            number: 15003,
            fmt: "lhh",
            args: [
                /**物品唯一id*/
                good_id: number,
                /**从哪里移*/
                from_pos: number,
                /**移到哪里*/
                to_pos: number
            ]
        ) => never;
        sendFmt: "lhh";
        sendArgs: [
            /**物品唯一id*/
            good_id: number,
            /**从哪里移*/
            from_pos: number,
            /**移到哪里*/
            to_pos: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    15004: {
        desc: "玩家整理背包仓库";
        send: (
            number: 15004,
            fmt: "h",
            args: [
                /**整理位置*/
                pos: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**整理位置*/
            pos: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    15005: {
        desc: "玩家拆分物品";
        send: (
            number: 15005,
            fmt: "li",
            args: [
                /**物品唯一id*/
                good_id: number,
                /**拆分数量*/
                num: number
            ]
        ) => never;
        sendFmt: "li";
        sendArgs: [
            /**物品唯一id*/
            good_id: number,
            /**拆分数量*/
            num: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    15006: {
        desc: "玩家物品续费";
        send: (
            number: 15006,
            fmt: "l",
            args: [
                /**物品唯一id*/
                good_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**物品唯一id*/
            good_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 物品唯一id */
            good_id: number;
            /** 结束时间 */
            expire_time: number;
        };
    };
    15007: {
        desc: "玩家物品过期提示(小天使小恶魔)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 物品id */
            good_id: number;
        };
    };
    15008: {
        desc: "更新一种特殊货币";
        send: (number: 15008, fmt: "i", args: [currency_id: number]) => never;
        sendFmt: "i";
        sendArgs: [currency_id: number];
        recv: {
            currency_id: number;
            num: number;
        };
    };
    15009: {
        desc: "获取所有特殊货币";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            currency_list: {
                currency_id: number;
                num: number;
            }[];
        };
    };
    15010: {
        desc: "列出玩家物品列表注:修改15010协议的时候要同时改15017协议注:后面如果有新协议用到15017打包物品的接口要在这里加上备注即时同步！！！！！！注:玩家身上的装备客户端自行请求15000协议更新缓存不要把一些详细信息的字段用15010|15017协议来更新";
        send: (
            number: 15010,
            fmt: "h",
            args: [
                /**物品位置，1 人物装备位置， 4 背包，7 装备背包 8 神器背包  13 灵器库 28 幻饰 29 幻饰背包*/
                pos: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**物品位置，1 人物装备位置， 4 背包，7 装备背包 8 神器背包  13 灵器库 28 幻饰 29 幻饰背包*/
            pos: number
        ];
        recv: {
            /** 物品位置 */
            pos: number;
            /** 该位置当前开启的格子数 */
            cell_num: number;
            /** 总的格子数 */
            max_cell: number;
            /** 单个格子的价格 */
            cell_gold: number;
            goods_list: {
                /** 物品Id */
                goods_id: number;
                /** 物品类型Id */
                type_id: number;
                /** 物品子位置(神器背包(8)：1(神器保护箱); 灵器库(13): sub_pos等于库id) */
                sub_pos: number;
                /** 物品所在格数 */
                cell: number;
                /** 物品数量 */
                goods_num: number;
                /** 物品绑定状态 */
                bind: number;
                /** 物品交易状态 */
                trade: number;
                /** 物品出售状态 */
                sell: number;
                /** 物品销毁状态 */
                is_drop: number;
                /** 颜色 */
                color: number;
                /** 过期时间戳 */
                expire_time: number;
                /** 战力 */
                combat_power: number;
                /** 强化等级 */
                stren: number;
                /** 物品等级 */
                level: number;
                /** 装备评分 */
                rating: number;
                /** 装备综合评分 */
                overall_rating: number;
                /** 附加属性 */
                addition_attrlist: {
                    /** 属性类型 */
                    attr_type: number;
                    /** 属性值 */
                    attr_value: number;
                    /** 属性颜色 */
                    color: number;
                    /** 战力 */
                    combat_power: number;
                }[];
                /** 装备附加属性(极品属性) */
                equip_extra_attr: {
                    /** 颜色 参考后台颜色配置 */
                    color: number;
                    /** 类型 1: 成长型属性 2: 百分比加成属性 */
                    type_id: number;
                    /** 属性类型 */
                    attr_id: number;
                    /** 属性值 */
                    attr_val: number;
                    /** 每多少级增加(成长型属性使用) */
                    plus_interval: number;
                    /** 每隔多少级增加多少属性(成长型属性使用) */
                    plus_unit: number;
                }[];
                /** 坐骑装备阶数 */
                equipStage: number;
                /** 坐骑装备星数 */
                equipStar: number;
                /** 技能id */
                skill_id: number;
                skill_lv: number;
                /** 属性觉醒 */
                awake_list: {
                    /** 属性类型 */
                    attr_type: number;
                    /** 觉醒等级 */
                    awake_lv: number;
                    /** 经验 */
                    awake_exp: number;
                }[];
            }[];
        };
    };
    15011: {
        desc: "查看玩家信息";
        send: (number: 15011, fmt: "l", args: [role_id: number]) => never;
        sendFmt: "l";
        sendArgs: [role_id: number];
        recv: {
            /** serverid */
            server_id: number;
            server_num: number;
            /** 角色id */
            role_id: number;
            /** 战力 */
            combat: number;
            /** 爵位等级 */
            achv_stage: number;
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
            equip_list: {
                /** 物品Id */
                goods_id: number;
                /** 物品类型Id */
                type_id: number;
                /** 物品所在格数 */
                cell: number;
                /** 颜色 */
                color: number;
                /** 强化等级 */
                stren: number;
                /** 星级 */
                star: number;
                /** 阶数 */
                stage: number;
                /** 等级 */
                level: number;
                /** 神装等级 */
                god_level: number;
            }[];
        };
    };
    15012: {
        desc: "查看跨服玩家信息";
        send: (
            number: 15012,
            fmt: "hl",
            args: [
                /**serverid*/
                server_id: number,
                /**角色Id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "hl";
        sendArgs: [
            /**serverid*/
            server_id: number,
            /**角色Id*/
            role_id: number
        ];
        recv: null;
    };
    15013: {
        desc: "查看跨服玩家的物品信息";
        send: (
            number: 15013,
            fmt: "hll",
            args: [
                /**serverid*/
                server_id: number,
                player_id: number,
                /**物品Id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "hll";
        sendArgs: [
            /**serverid*/
            server_id: number,
            player_id: number,
            /**物品Id*/
            goods_id: number
        ];
        recv: null;
    };
    15014: {
        desc: "查看玩家战力对比信息";
        send: (number: 15014, fmt: "l", args: [role_id: number]) => never;
        sendFmt: "l";
        sendArgs: [role_id: number];
        recv: {
            /** serverid */
            server_id: number;
            role_id: number;
            /** 装备，套装，宝石，密宝四个，时装，圣裁，坐骑的七个，圣印， 情缘2个， */
            power_list: {
                /** 战力 */
                power: number;
            }[];
            /** 装备，套装，宝石，密宝四个，时装，圣裁，坐骑的七个，圣印， 情缘2个， */
            self_power_list: {
                /** 战力 */
                power: number;
            }[];
        };
    };
    15015: {
        desc: "查看跨服玩家战力对比信息";
        send: (
            number: 15015,
            fmt: "hl",
            args: [
                /**serverid*/
                server_id: number,
                /**角色Id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "hl";
        sendArgs: [
            /**serverid*/
            server_id: number,
            /**角色Id*/
            role_id: number
        ];
        recv: null;
    };
    15017: {
        desc: "更新物品信息、增加物品注:如果只是更新物品的数量信息请走15018协议";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 物品位置 */
            pos: number;
            goods_list: {
                /** 物品Id */
                goods_id: number;
                /** 物品类型Id */
                type_id: number;
                /** 物品子位置 */
                sub_pos: number;
                /** 物品所在格数 */
                cell: number;
                /** 物品数量 */
                goods_num: number;
                /** 物品绑定状态 */
                bind: number;
                /** 物品交易状态 */
                trade: number;
                /** 物品出售状态 */
                sell: number;
                /** 物品销毁状态 */
                is_drop: number;
                /** 颜色 */
                color: number;
                /** 过期时间戳 */
                expire_time: number;
                /** 战力 */
                combat_power: number;
                /** 强化等级 */
                stren: number;
                /** 物品等级 */
                level: number;
                /** 装备评分 */
                rating: number;
                /** 装备综合评分 */
                overall_rating: number;
                /** 附加属性 */
                addition_attrlist: {
                    /** 属性类型 */
                    attr_type: number;
                    /** 属性值 */
                    attr_value: number;
                    /** 属性颜色 */
                    color: number;
                    /** 战力 */
                    combat_power: number;
                }[];
                /** 装备附加属性(极品属性) */
                equip_extra_attr: {
                    /** 颜色 参考后台颜色配置 */
                    color: number;
                    /** 类型 1: 成长型属性 2: 百分比加成属性 */
                    type_id: number;
                    /** 属性类型 */
                    attr_id: number;
                    /** 属性值 */
                    attr_val: number;
                    /** 每多少级增加(成长型属性使用) */
                    plus_interval: number;
                    /** 每隔多少级增加多少属性(成长型属性使用) */
                    plus_unit: number;
                }[];
                /** 坐骑装备阶数 */
                equipStage: number;
                /** 坐骑装备星数 */
                equipStar: number;
                skill_id: number;
                skill_lv: number;
                /** 属性觉醒 */
                awake_list: {
                    /** 属性类型 */
                    attr_type: number;
                    /** 觉醒等级 */
                    awake_lv: number;
                    /** 经验 */
                    awake_exp: number;
                }[];
            }[];
        };
    };
    15018: {
        desc: "更新物品数量(若物品数量为0,即是要删除的物品)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 物品位置 */
            pos: number;
            goods_list: {
                /** 物品Id */
                goods_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 物品类型Id */
                type_id: number;
            }[];
        };
    };
    15019: {
        desc: "物品分解";
        send: (number: 15019, fmt: any, args: [goods_list: any]) => never;
        sendFmt: any;
        sendArgs: [goods_list: any];
        recv: {
            /** 错误码 */
            code: number;
            reward_list: {
                /** 物品唯一id */
                goods_id: number;
                /** 物品数量 */
                goods_num: number;
            }[];
        };
    };
    15020: {
        desc: "物品合成";
        send: (
            number: 15020,
            fmt: "iAA",
            args: [
                /**合成规则id*/
                rule_id: number,
                /**指定扣除物品(固定材料)*/
                regular_glist: any,
                /**指定扣除物品(随机材料)*/
                specify_glist: any
            ]
        ) => never;
        sendFmt: "iAA";
        sendArgs: [
            /**合成规则id*/
            rule_id: number,
            /**指定扣除物品(固定材料)*/
            regular_glist: any,
            /**指定扣除物品(随机材料)*/
            specify_glist: any
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 合成类型 0:普通类型 1:戒指手镯特殊合成 */
            compose_type: number;
            /** 合成规则id */
            rule_id: number;
            /** 合成的物品id */
            goods_id: number;
        };
    };
    15021: {
        desc: "出售物品";
        send: (number: 15021, fmt: any, args: [goods_list: any]) => never;
        sendFmt: any;
        sendArgs: [goods_list: any];
        recv: {
            /** 返回码 */
            res: number;
            type_id_list: {
                /** 物品Id */
                type_id: number;
                /** 物品数量 */
                num: number;
            }[];
        };
    };
    15022: {
        desc: "物品兑换";
        send: (
            number: 15022,
            fmt: "li",
            args: [
                /**兑换id*/
                id: number,
                /**数量*/
                num: number
            ]
        ) => never;
        sendFmt: "li";
        sendArgs: [
            /**兑换id*/
            id: number,
            /**数量*/
            num: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 兑换id */
            id: number;
            /** 兑换类型 */
            type: number;
        };
    };
    15023: {
        desc: "更改物品子位置：神装武器放进保护箱";
        send: (
            number: 15023,
            fmt: "l",
            args: [
                /**物品id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**物品id*/
            id: number
        ];
        recv: {
            /** 错误码 1 成功 */
            errcode: number;
            /** 物品id */
            id: number;
            /** 背包类型 */
            pos: number;
            /** 物品子位置 */
            sub_pos: number;
        };
    };
    15024: {
        desc: "背包熔炼信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 等级 */
            level: number;
            /** 经验 */
            exp: number;
        };
    };
    15025: {
        desc: "背包熔炼";
        send: (number: 15025, fmt: any, args: [goods_list: any]) => never;
        sendFmt: any;
        sendArgs: [goods_list: any];
        recv: {
            code: number;
            exp_list: {
                /** 增加的经验值 (暂时只有产生2倍以上暴击才会返回) */
                add_exp: number;
                /** 暴击比率 */
                ratio: number;
            }[];
        };
    };
    15026: {
        desc: "物品兑换列表";
        send: (
            number: 15026,
            fmt: "h",
            args: [
                /**兑换类型*/
                type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**兑换类型*/
            type: number
        ];
        recv: {
            /** 兑换类型 */
            type: number;
            exchange_list: {
                /** 兑换规则id */
                id: number;
                count: number;
                /** 是否满足兑换条件， 1满足0不满足 */
                can_exchange: number;
            }[];
        };
    };
    15027: {
        desc: "过期物品列表";
        send: (
            number: 15027,
            fmt: "c",
            args: [
                /**1:查看过期物品 2:回收过期物品*/
                opr: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1:查看过期物品 2:回收过期物品*/
            opr: number
        ];
        recv: {
            /** 查看过期物品 */
            opr: number;
            goods_list: {
                /** 物品id */
                goods_id: number;
                /** 类型id */
                type_id: number;
                /** 数量 */
                goods_num: number;
            }[];
        };
    };
    15028: {
        desc: "物品合成（非指定特定物品）";
        send: (
            number: 15028,
            fmt: "iiAA",
            args: [
                /**合成规则id*/
                rule_id: number,
                /**合成数量*/
                compose_num: number,
                /**(固定材料)*/
                regular_glist: any,
                /**(随机材料)*/
                irregular_glist: any
            ]
        ) => never;
        sendFmt: "iiAA";
        sendArgs: [
            /**合成规则id*/
            rule_id: number,
            /**合成数量*/
            compose_num: number,
            /**(固定材料)*/
            regular_glist: any,
            /**(随机材料)*/
            irregular_glist: any
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 合成规则id */
            rule_id: number;
            rewards: any;
        };
    };
    15029: {
        desc: "背包状态推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            state: number;
            /** 背包类型 */
            location: number;
        };
    };
    15030: {
        desc: "通知客户端重新请求物品背包数据(走一次登录请求物品流程)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    15050: {
        desc: "使用物品";
        send: (
            number: 15050,
            fmt: "li",
            args: [
                /**物品Id*/
                goods_id: number,
                /**数量*/
                num: number
            ]
        ) => never;
        sendFmt: "li";
        sendArgs: [
            /**物品Id*/
            goods_id: number,
            /**数量*/
            num: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /**  参数 */
            args: string;
            /** 物品Id */
            goods_id: number;
            /** 物品类型Id，失败为0 */
            goods_type_id: number;
            /** 新物品数量，失败为0 */
            goods_num: number;
            /** 人物当前气血，失败为0 */
            hp: number;
            /** 数量 */
            num: number;
            show_goods: {
                /** 物品唯一id */
                gid: number;
                /** 物品类型 */
                type: number;
                /** 物品类型Id，失败为0 */
                goodid: number;
                /** 新物品数量，失败为0 */
                gnum: number;
            }[];
        };
    };
    15053: {
        desc: "拣取地上掉落包的物品1.没有拾取时间的发送一次就行2.有拾取时间的发送两次";
        send: (
            number: 15053,
            fmt: "l",
            args: [
                /**掉落包Id*/
                drop_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**掉落包Id*/
            drop_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /**  参数 */
            args: string;
            /** 状态##防止返回码被修改,重要数据要根据status来操作 */
            status: number;
            /** 掉落包Id */
            drop_id: number;
        };
    };
    15055: {
        desc: "获取buff列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            player_id: number;
            buff_list: {
                /** buff_type为0时，为buff物品类型Id：有物品id时候，图标根据物品id去查找 */
                goods_id: number;
                /** buff类型（1-254）：图标根据buff类型，客户端特殊处理 */
                buff_type: number;
                /**  效果列表 其中[{attr,Attr}]Attr为属性数据，如有别的数据则特殊说明 */
                effect_list: string;
                /** 剩余持续时间(秒) */
                time: number;
                /** 物品buff才有意义，单个物品的buff持续时间(秒) 0:表示这个buff需要服务端手动移除 */
                single_time: number;
            }[];
        };
    };
    15083: {
        desc: "礼包的等级信息";
        send: (
            number: 15083,
            fmt: "li",
            args: [
                /**物品id*/
                goods_id: number,
                type_id: number
            ]
        ) => never;
        sendFmt: "li";
        sendArgs: [
            /**物品id*/
            goods_id: number,
            type_id: number
        ];
        recv: {
            /** 物品id */
            goods_id: number;
            type_id: number;
            gift_level: number;
        };
    };
    15084: {
        desc: "次数礼包使用次数信息";
        send: (
            number: 15084,
            fmt: "l",
            args: [
                /**物品id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**物品id*/
            goods_id: number
        ];
        recv: {
            /** 物品id */
            goods_id: number;
            /** 已使用次数 */
            use_count: number;
            /** 总次数 */
            total_count: number;
            /** 下次可使用时间 */
            freeze_endtime: number;
        };
    };
    15085: {
        desc: "礼包每天使用次数";
        send: (
            number: 15085,
            fmt: "i",
            args: [
                /**礼包物品id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**礼包物品id*/
            goods_id: number
        ];
        recv: {
            /** 礼包物品id */
            goods_id: number;
            /** 礼包使用次数 */
            count: number;
        };
    };
    15086: {
        desc: "领取自选礼包物品内容";
        send: (
            number: 15086,
            fmt: "lA",
            args: [
                /**物品唯一ID*/
                gift_id: number,
                seq_list: any
            ]
        ) => never;
        sendFmt: "lA";
        sendArgs: [
            /**物品唯一ID*/
            gift_id: number,
            seq_list: any
        ];
        recv: {
            /** 结果 */
            code: number;
        };
    };
    15087: {
        desc: "领取礼包卡奖励";
        send: (
            number: 15087,
            fmt: "s",
            args: [
                /**卡号*/
                card_no: string
            ]
        ) => never;
        sendFmt: "s";
        sendArgs: [
            /**卡号*/
            card_no: string
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 奖励列表 */
            reward_list: any;
        };
    };
    15088: {
        desc: "拾取掉落包顺序列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            drop_id_list: {
                /** 掉落包id */
                drop_id: number;
            }[];
        };
    };
    15089: {
        desc: "查看某些物品的预览战力";
        send: (
            number: 15089,
            fmt: "i",
            args: [
                /**物品类型id*/
                goods_type_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**物品类型id*/
            goods_type_id: number
        ];
        recv: {
            /** 物品类型id */
            goods_type_id: number;
            expect_power: number;
        };
    };
    15090: {
        desc: "物品自动分解提示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            reward_list: {
                /** 物品唯一id */
                goods_id: number;
                /** 物品数量 */
                goods_num: number;
            }[];
            /** 背包类型，11：符文，15：源力，43：龙语 */
            goods_bag_type: number;
            /** 某种颜色类型之下(蓝色：2，紫色：3，没有颜色限制：0) */
            under_color: number;
        };
    };
}
