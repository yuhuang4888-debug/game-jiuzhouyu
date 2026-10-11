/** 祭典
 */
declare interface ProtoFmtInfo {
    19501: {
        desc: "申请查看玩家各功能模块信息";
        send: (
            number: 19501,
            fmt: "hlh",
            args: [
                /**serverid, 本服可以发0或对应服务器Id*/
                server_id: number,
                role_id: number,
                /**1-人物基础信息(装备),2-星核,3-影装,4-神祭,5-幻化...*/
                module_id: number
            ]
        ) => never;
        sendFmt: "hlh";
        sendArgs: [
            /**serverid, 本服可以发0或对应服务器Id*/
            server_id: number,
            role_id: number,
            /**1-人物基础信息(装备),2-星核,3-影装,4-神祭,5-幻化...*/
            module_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    19502: {
        desc: "人物基础信息(装备)服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** serverid */
            server_id: number;
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
            magic_circle: {
                lv: number;
                /** 0-未激活 1-已激活 */
                is_open: number;
                /** 0：没有免费体验  1：可以免费体验  2正在免费体验 */
                free_flag: number;
                /** 结束时间戳 */
                end_time: number;
            }[];
        };
    };
    19503: {
        desc: "查看人物信息-星核界面服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 星核总战力 */
            sum_power: number;
            ball_list: {
                /** 星核ID */
                dragon_ball_id: number;
                /** 星核等级 */
                level: number;
                /** 星核战力 */
                power: number;
            }[];
            skill_attr: {
                /** 属性id */
                attr: number;
                /** 等级 */
                value: number;
            }[];
        };
    };
    19504: {
        desc: "查看人物信息-影装/神祭界面服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 系统类型 3-影装 4-神祭 */
            sys_type: number;
            /** 装备+套装，总评分 */
            rating: number;
            /** 总战力 */
            sum_power: number;
            pos_list: {
                pos: number;
                type_id: number;
                goods_id: number;
                attr_list: {
                    /** 属性id */
                    attr: number;
                    /** 等级 */
                    value: number;
                }[];
                /** 单件装备的评分 */
                rating: number;
                /** 强化等级 */
                strong: number;
                /** 物品所在格子数(系统类型为3-影装才有值，其余情况为0) */
                cell: number;
            }[];
            pill_list: {
                /** 圣魂丹(影魂)物品类型ID */
                goods_id: number;
                /** 总数量 */
                total_num: number;
                attr_list: {
                    /** 属性id */
                    attr: number;
                    /** 等级 */
                    value: number;
                }[];
            }[];
            stren_attr: {
                /** 属性id */
                attr: number;
                /** 等级 */
                value: number;
            }[];
            equip_attr: {
                /** 属性id */
                attr: number;
                /** 等级 */
                value: number;
            }[];
            pill_attr: {
                /** 属性id */
                attr: number;
                /** 等级 */
                value: number;
            }[];
            suit_attr: {
                /** 属性id */
                attr: number;
                /** 等级 */
                value: number;
            }[];
            suit_list: {
                /** 套装ID */
                suit_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    19505: {
        desc: "查看人物信息-天启界面服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 最大形象id */
            max_figure_id: number;
            /** 当前形象id */
            current_figure_id: number;
            /** 总战力 */
            power: number;
            /** 总评分 */
            all_score: number;
            /** 聚灵信息 */
            gathering: {
                /** 位置 */
                pos: number;
                /** 等级 */
                lv: number;
                /** 经验 */
                exp: number;
                /** 是否有效   0无效 1 有效 */
                flag: number;
                /** 物品的唯一ID */
                equip_id: number;
                /** 装备类型ID */
                item_id: number;
                /** 单个评分 */
                score: number;
            }[];
            /** 套装信息 */
            suit: {
                /** 星数 */
                star: number;
                /** 数量 */
                num: number;
            }[];
            skill_list: {
                /** 技能id */
                skill_id: number;
                /** 等级 */
                lv: number;
            }[];
        };
    };
    19506: {
        desc: "查看人物信息-幻化总界面服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 幻化总战力 */
            sum_power: number;
            /** 幻化总数量 */
            illusion_num: number;
            illusion_list: {
                /** 坐骑类型 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 */
                type: number;
                /** 该坐骑类型幻化数量 */
                num: number;
                /** 该坐骑类型幻化总战力 */
                power: number;
                figure_list: {
                    /** 坐骑类的幻化类型，1-基本功能形象，2-幻化界面的形象 */
                    figure_type: number;
                    /** 幻化形象ID(当figure_type为1时，这里为0) */
                    id: number;
                    /** 幻化形象阶数 */
                    stage: number;
                    /** 幻化星数 */
                    star: number;
                    /** 战力 */
                    combat: number;
                    /** 结束时间时间 */
                    end_time: number;
                    /** 当figure_type为1时，这里表示该坐骑类总的属性加成 */
                    attr_list: {
                        /** 属性类型 */
                        attr_id: number;
                        /** 属性值 */
                        attr_val: number;
                    }[];
                    /** 当figure_type为1时，这里为空 */
                    star_attr_list: {
                        /** 属性类型 */
                        attr_id: number;
                        /** 属性值 */
                        attr_val: number;
                    }[];
                    /** 解锁技能列表 */
                    skill_list: {
                        /** 技能id */
                        skill_id: number;
                    }[];
                }[];
            }[];
            fashion_pos: {
                /** 1-衣服、2、武器、3-头部、4-足部 */
                pos_id: number;
                /** 时装等级 */
                pos_lv: number;
                /** 穿着的时装ID */
                wear_fashion_id: number;
                /** 时装激活列表 */
                fashion_list: {
                    /** 时装id */
                    fashion_id: number;
                    /** 阶级 */
                    star_lv: number;
                    /** 时装战力 */
                    combat: number;
                    /** 当前颜色 */
                    now_color_id: number;
                    /** 玩家在该时装所拥有的颜色与对应星数的映射[{color_id, star_lv}] */
                    color_list: {
                        /** 颜色ID */
                        color_id: number;
                        /** 阶级 */
                        star_lv: number;
                    }[];
                }[];
            }[];
            /** 申请者自身的战力列表 */
            self_power: {
                /** 坐骑类型 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 */
                type: number;
                /** 战力 */
                combat: number;
            }[];
            /** 被查看玩家的战力列表 */
            others_power: {
                /** 坐骑类型 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 */
                type: number;
                /** 战力 */
                combat: number;
            }[];
        };
    };
    19507: {
        desc: "查看人物信息-降神界面服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 降神总战力 */
            god_sum_power: number;
            /** 当前变身出战的降神信息列表 */
            god_battle_info: {
                /** 孔位 0 - 表示玩家激活的但未出战的降神，其他则表示出战 */
                battle_pos: number;
                /** 当前出战的降神ID */
                god_id: number;
                /** 等级 */
                lv: number;
                /** 当前阶数 */
                grade: number;
                /** 星级 */
                star: number;
                /** 出战降神的战力 */
                power: number;
                /** 神格强化等级 */
                god_stren: number;
                equip_list: {
                    /** 位置 */
                    pos: number;
                    /** 物品类型id */
                    goods_id: number;
                }[];
            }[];
        };
    };
    19508: {
        desc: "查看人物信息-灵饰界面服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 灵饰总评分 */
            score: number;
            /** 当前已解锁的部位信息 */
            decoration_list: {
                /** 装备位置 */
                pos: number;
                /** 物品类型id */
                goods_id: number;
                /** 强化等级 */
                lv: number;
                /** 强化评分 */
                stren_score: number;
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
            }[];
        };
    };
    19509: {
        desc: "查看人物信息-神纹界面服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 神纹总战力 */
            all_power: number;
            /** 神纹总等级 */
            all_level: number;
            /** 当前已解锁的部位信息 */
            dragon_equip_list: {
                /** 位置 */
                pos: number;
                /** 位置等级 */
                pos_lv: number;
                /** 装备的神纹物品类型id */
                goods_id: number;
                /** 强化等级 */
                stren_lv: number;
                /** 觉醒等级 */
                awake_lv: number;
                /** 单个神纹的战力 */
                combat: number;
            }[];
        };
    };
    19510: {
        desc: "查看人物信息-蜃妖界面服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 蜃妖总评分 */
            all_score: number;
            /** 最大助战数量 */
            max_num: number;
            /** 当前助战数量 */
            battle_num: number;
            /** 玩家已激活的蜃妖列表 */
            eudemons_list: {
                /** 蜃妖ID */
                id: number;
                /** 状态 0休眠 1激活 2出战 */
                state: number;
                /** 单个蜃妖的评分 */
                score: number;
                /** 身上装备 */
                equip_list: {
                    /** 位置 */
                    pos: number;
                    /** 物品类型id, */
                    goods_id: number;
                    /** 强化等级 */
                    stren: number;
                    /** 单件装备的评分 */
                    equip_score: number;
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
                }[];
            }[];
        };
    };
    19511: {
        desc: "查看人物信息-神巫妖灵界面服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 神巫总战力 */
            companion_power: number;
            /** 神巫列表 */
            companion_list: {
                /** 神巫ID */
                id: number;
                /** 阶数 */
                stage: number;
                /** 星数 */
                star: number;
                /** 是否出战 0-未出战 1-出战 */
                is_fight: number;
                /** 使用魂珠的数量 */
                train_num: number;
                /** 单个战力 */
                combat: number;
                /** 技能列表 */
                skill_list: {
                    /** 技能ID */
                    skill_id: number;
                    /** 技能等级 */
                    level: number;
                }[];
            }[];
            /** 妖灵总战力 */
            demons_power: number;
            /** 当前出战的妖灵 */
            battle_demons: number;
            demons_list: {
                /** 妖灵Id */
                id: number;
                /** 妖灵等级 */
                level: number;
                /** 妖灵星级 */
                star: number;
                /** 妖灵已解锁的槽位个数 */
                slot_num: number;
                /** 单个妖灵的战力 */
                combat: number;
                /** 妖灵基础技能列表 */
                skill_list: {
                    skill_id: number;
                    skill_lv: number;
                    /** 技能进度#生活技能专有 */
                    process: number;
                    /** 技能是否已激活 */
                    is_active: number;
                }[];
                /** 妖灵天赋技能列表 */
                slot_skill: {
                    sk_id: number;
                    sk_lv: number;
                    /** 槽位 */
                    slot: number;
                    /** 品质 */
                    quality: number;
                    /** 种类 */
                    sort: number;
                }[];
            }[];
        };
    };
    19512: {
        desc: "查看人物信息-御魂界面服务端推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 御魂总战力 */
            all_power: number;
            /** 御魂技能等级 */
            skill_level: number;
            /** 槽位列表 */
            rune_list: {
                /** 槽位id */
                pos_id: number;
                /** 御魂唯一id */
                goods_id: number;
                /** 御魂物品类型id */
                goods_type_id: number;
                /** 品质 */
                color: number;
                /** 物品等级 */
                lv: number;
                /** 符文总觉醒等级 */
                sum_awake_lv: number;
                /** 属性列表 */
                attr_list: {
                    /** 属性类型 */
                    attr_id: number;
                    /** 属性基础值 */
                    attr_num: number;
                    /** 觉醒等级 */
                    awake_lv: number;
                }[];
            }[];
        };
    };
}
