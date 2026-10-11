/** 装备信息
 */
declare interface ProtoFmtInfo {
    15200: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            res: number;
        };
    };
    15201: {
        desc: "穿戴装备";
        send: (
            number: 15201,
            fmt: "l",
            args: [
                /**装备物品Id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**装备物品Id*/
            goods_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 物品Id */
            goods_id: number;
            /** 旧的装备物品Id */
            old_goods_id: number;
            /** 物品类型id */
            type_id: number;
            /** 装备格子位置 */
            cell_pos: number;
        };
    };
    15202: {
        desc: "卸下装备";
        send: (
            number: 15202,
            fmt: "l",
            args: [
                /**装备物品Id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**装备物品Id*/
            goods_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 物品Id */
            goods_id: number;
            /** 背包格子位置，失败为0 */
            cell: number;
        };
    };
    15204: {
        desc: "强化信息";
        send: (
            number: 15204,
            fmt: "c",
            args: [
                /**装备位置*/
                equip_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备位置*/
            equip_type: number
        ];
        recv: {
            /** 返回码  1:成功  0 装备位置参数错误 */
            res: number;
            /** 装备位置 */
            equip_type: number;
            /** 强化等级 */
            stren: number;
        };
    };
    15205: {
        desc: "强化装备";
        send: (
            number: 15205,
            fmt: "cc",
            args: [
                /**装备位置*/
                equip_type: number,
                /**1: 单次强化 2: 一键强化*/
                type: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**装备位置*/
            equip_type: number,
            /**1: 单次强化 2: 一键强化*/
            type: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 一键强化失败的装备位置 */
            res1: number;
            /** 1: 单次强化 2: 一键强化 */
            type: number;
            stren_info: {
                /** 装备位置 */
                equip_type: number;
                /** 强化等级 */
                stren: number;
            }[];
        };
    };
    15206: {
        desc: "进阶装备";
        send: (
            number: 15206,
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
            /** 返回码 */
            res: number;
            /** 物品id */
            goods_id: number;
        };
    };
    15207: {
        desc: "进阶属性预览";
        send: (
            number: 15207,
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
            /** 物品类型id */
            type_id: number;
            /** 装备评分 */
            rating: number;
            /** 装备综合评分 */
            overall_rating: number;
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
        };
    };
    15208: {
        desc: "宝石镶嵌";
        send: (
            number: 15208,
            fmt: "ccl",
            args: [
                /**装备位置*/
                equip_type: number,
                /**宝石孔位置*/
                pos: number,
                /**宝石物品Id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "ccl";
        sendArgs: [
            /**装备位置*/
            equip_type: number,
            /**宝石孔位置*/
            pos: number,
            /**宝石物品Id*/
            type_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 装备位置 */
            equip_type: number;
            /** 宝石孔位置 */
            pos: number;
            /** 宝石物品类型Id */
            type_id: number;
        };
    };
    15209: {
        desc: "宝石拆除";
        send: (
            number: 15209,
            fmt: "cc",
            args: [
                /**装备位置*/
                equip_type: number,
                /**宝石孔位置*/
                pos: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**装备位置*/
            equip_type: number,
            /**宝石孔位置*/
            pos: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 装备位置 */
            equip_type: number;
            /** 宝石孔位置 */
            pos: number;
        };
    };
    15210: {
        desc: "宝石精炼信息";
        send: (
            number: 15210,
            fmt: "c",
            args: [
                /**装备位置*/
                equip_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备位置*/
            equip_type: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 装备位置 */
            equip_type: number;
            /** 精炼等级 */
            refine_lv: number;
            /** 经验值 */
            exp: number;
            attr_list: {
                /** 属性id */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
        };
    };
    15211: {
        desc: "宝石精炼";
        send: (
            number: 15211,
            fmt: "cic",
            args: [
                /**装备位置*/
                equip_type: number,
                /**精炼道具物品类型id*/
                type_id: number,
                /**0 精炼 1 一键精炼*/
                one_key: number
            ]
        ) => never;
        sendFmt: "cic";
        sendArgs: [
            /**装备位置*/
            equip_type: number,
            /**精炼道具物品类型id*/
            type_id: number,
            /**0 精炼 1 一键精炼*/
            one_key: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 装备位置 */
            equip_type: number;
            /** 0: 没有升级 1: 已升级 */
            is_up: number;
            /** 0 精炼 1 一键精炼 */
            one_key: number;
        };
    };
    15212: {
        desc: "开启洗炼属性槽";
        send: (
            number: 15212,
            fmt: "cc",
            args: [
                /**装备位置*/
                equip_type: number,
                /**第几个属性槽*/
                index: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**装备位置*/
            equip_type: number,
            /**第几个属性槽*/
            index: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 物品id */
            goods_id: number;
            /** 第几个属性槽 */
            index: number;
        };
    };
    15213: {
        desc: "洗炼装备";
        send: (
            number: 15213,
            fmt: "cAc",
            args: [
                /**装备位置*/
                equip_type: number,
                lock_list: any,
                /**0：普通洗练 1：紫色保底 2：红色保底 3：橙色保底*/
                ratio_plus: number
            ]
        ) => never;
        sendFmt: "cAc";
        sendArgs: [
            /**装备位置*/
            equip_type: number,
            lock_list: any,
            /**0：普通洗练 1：紫色保底 2：红色保底 3：橙色保底*/
            ratio_plus: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 物品id */
            goods_id: number;
            attr_list: {
                /** 第几个属性槽 */
                index: number;
            }[];
        };
    };
    15214: {
        desc: "免费次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 获取免费次数 */
            free_times: number;
        };
    };
    15215: {
        desc: "宝石升级";
        send: (
            number: 15215,
            fmt: "ccc",
            args: [
                /**装备位置*/
                equip_type: number,
                /**孔位置*/
                pos: number,
                /**0 普通 1 一键(使用低等级宝石) 2直升丹直升一级*/
                upgrade_type: number
            ]
        ) => never;
        sendFmt: "ccc";
        sendArgs: [
            /**装备位置*/
            equip_type: number,
            /**孔位置*/
            pos: number,
            /**0 普通 1 一键(使用低等级宝石) 2直升丹直升一级*/
            upgrade_type: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 装备位置 */
            equip_type: number;
            /** 孔位置 */
            pos: number;
            /** 宝石物品类型Id */
            type_id: number;
        };
    };
    15216: {
        desc: "宝石合成";
        send: (
            number: 15216,
            fmt: "ic",
            args: [
                /**物品类型id*/
                type_id: number,
                /**0 普通 1 一键*/
                is_one_key: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**物品类型id*/
            type_id: number,
            /**0 普通 1 一键*/
            is_one_key: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 物品类型id */
            type_id: number;
            /** 0 普通 1 一键 */
            is_one_key: number;
        };
    };
    15217: {
        desc: "神装信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 神装总战力 */
            total_power: number;
            god_info: {
                /** 装备部位 */
                pos: number;
                /** 阶数 */
                level: number;
            }[];
        };
    };
    15218: {
        desc: "神装升阶";
        send: (
            number: 15218,
            fmt: "c",
            args: [
                /**装备部位*/
                pos: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备部位*/
            pos: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    15219: {
        desc: "神装升阶预览";
        send: (
            number: 15219,
            fmt: "c",
            args: [
                /**装备部位*/
                pos: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备部位*/
            pos: number
        ];
        recv: {
            /** 升阶增加的战力 */
            power: number;
        };
    };
    15220: {
        desc: "装备套装信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            suit_list: {
                /** 装备位置 */
                equip_type: number;
                /** 套装等级 */
                lv: number;
                /** 第几阶 */
                slv: number;
            }[];
        };
    };
    15221: {
        desc: "打造套装";
        send: (
            number: 15221,
            fmt: "cc",
            args: [
                /**套装等级 1 屠魔 2 弑神*/
                lv: number,
                /**装备位置（1-10 包括装备和饰品）*/
                equip_type: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**套装等级 1 屠魔 2 弑神*/
            lv: number,
            /**装备位置（1-10 包括装备和饰品）*/
            equip_type: number
        ];
        recv: {
            /** 装备位置 */
            equip_type: number;
            /** 套装等级 */
            lv: number;
            /** 第几阶 */
            slv: number;
            /** 套装属性 */
            suit_list: {
                /** 套装等级 */
                suit_lv: number;
                /** 第几阶 */
                suit_slv: number;
                /** 目前有几件 */
                suit_count: number;
            }[];
        };
    };
    15222: {
        desc: "还原套装";
        send: (
            number: 15222,
            fmt: "cc",
            args: [
                /**套装等级 1 屠魔 2 弑神*/
                lv: number,
                /**装备位置*/
                equip_type: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**套装等级 1 屠魔 2 弑神*/
            lv: number,
            /**装备位置*/
            equip_type: number
        ];
        recv: {
            /** 装备位置 */
            equip_type: number;
            /** 套装等级 */
            lv: number;
            /** 第几阶 */
            slv: number;
            reward_list: {
                /** 0：物品 101：带属性的物品 */
                type: number;
                /** 物品配置id */
                id: number;
                num: number;
                /**  物品的属性 [{bind,1|0}] */
                attr_list: string;
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
        };
    };
    15223: {
        desc: "还原套装奖励预览";
        send: (
            number: 15223,
            fmt: "cc",
            args: [
                /**套装等级 1 屠魔 2 弑神*/
                lv: number,
                /**装备位置*/
                equip_type: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**套装等级 1 屠魔 2 弑神*/
            lv: number,
            /**装备位置*/
            equip_type: number
        ];
        recv: {
            /** 装备位置 */
            equip_type: number;
            /** 套装等级 */
            lv: number;
            reward_list: {
                /** 0：物品 101：带属性的物品 */
                type: number;
                /** 物品配置id */
                id: number;
                num: number;
                /**  物品的属性 [{bind,1|0}] */
                attr_list: string;
            }[];
        };
    };
    15230: {
        desc: "铸灵信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 诛神塔历史最高积分 */
            score: number;
            /** 只发已经进行铸灵的装备部位 */
            list: {
                /** 装备位置 */
                equip_type: number;
                /** 阶数 */
                stage: number;
                /** 等级 */
                lv: number;
            }[];
        };
    };
    15231: {
        desc: "铸灵";
        send: (
            number: 15231,
            fmt: "c",
            args: [
                /**装备位置*/
                equip_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备位置*/
            equip_type: number
        ];
        recv: {
            /** 返回码   失败了走15200协议 这里的返回码是1 */
            errcode: number;
            /** 装备位置 */
            equip_type: number;
            /** 阶数 */
            stage: number;
            /** 等级 */
            lv: number;
        };
    };
    15232: {
        desc: "护灵界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 等级 */
            lv: number;
        };
    };
    15233: {
        desc: "护灵";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码   失败了走15200协议 这里的返回码是1 */
            errcode: number;
            /** 等级 */
            lv: number;
        };
    };
    15241: {
        desc: "觉醒";
        send: (
            number: 15241,
            fmt: "c",
            args: [
                /**装备位置*/
                equip_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备位置*/
            equip_type: number
        ];
        recv: {
            /** 返回码   失败了走15200协议 这里的返回码是1 */
            errcode: number;
            /** 装备位置 */
            equip_type: number;
        };
    };
    15244: {
        desc: "唤魔技能操作";
        send: (
            number: 15244,
            fmt: "cci",
            args: [
                /**装备部位*/
                equip_type: number,
                /**1: 附加技能 2: 卸下技能*/
                type: number,
                /**附加技能id(卸下技能时候传0)*/
                skill_id: number
            ]
        ) => never;
        sendFmt: "cci";
        sendArgs: [
            /**装备部位*/
            equip_type: number,
            /**1: 附加技能 2: 卸下技能*/
            type: number,
            /**附加技能id(卸下技能时候传0)*/
            skill_id: number
        ];
        recv: {
            /** 返回码   失败了走15200协议 这里的返回码是1 */
            errcode: number;
            /** 装备部位 */
            equip_type: number;
            /** 1: 附加技能 2: 卸下技能 */
            type: number;
        };
    };
    15245: {
        desc: "唤魔技能升级";
        send: (
            number: 15245,
            fmt: "c",
            args: [
                /**装备部位*/
                equip_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备部位*/
            equip_type: number
        ];
        recv: {
            /** 返回码   失败了走15200协议 这里的返回码是1 */
            errcode: number;
            /** 装备部位 */
            equip_type: number;
        };
    };
    15250: {
        desc: "精炼信息";
        send: (
            number: 15250,
            fmt: "c",
            args: [
                /**装备位置*/
                equip_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备位置*/
            equip_type: number
        ];
        recv: {
            /** 返回码  1:成功  0 装备位置参数错误 */
            res: number;
            /** 装备位置 */
            equip_type: number;
            /** 精炼等级 */
            refine: number;
            /** 最高（真实）精炼等级 */
            refine_high: number;
        };
    };
    15251: {
        desc: "精炼装备";
        send: (
            number: 15251,
            fmt: "cc",
            args: [
                /**装备位置*/
                equip_type: number,
                /**1: 单次精炼 2: 一键精炼*/
                type: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**装备位置*/
            equip_type: number,
            /**1: 单次精炼 2: 一键精炼*/
            type: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 一键精炼失败的装备位置 */
            res1: number;
            /** 1: 单次精炼 2: 一键精炼 */
            type: number;
            refine_info: {
                /** 装备位置 */
                equip_type: number;
                /** 最高（真实）精炼等级 */
                refine_high: number;
            }[];
        };
    };
    15252: {
        desc: "升段";
        send: (
            number: 15252,
            fmt: "cc",
            args: [
                /**装备位置*/
                equip_type: number,
                /**0:不自动购买 1：自动购买*/
                is_buy: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**装备位置*/
            equip_type: number,
            /**0:不自动购买 1：自动购买*/
            is_buy: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 物品id */
            goods_id: number;
        };
    };
    15253: {
        desc: "神装升阶";
        send: (
            number: 15253,
            fmt: "c",
            args: [
                /**部位*/
                pos: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**部位*/
            pos: number
        ];
        recv: {
            /** 返回码 1成功，其他失败 */
            code: number;
        };
    };
    15254: {
        desc: "获取装备模块子功能战力";
        send: (
            number: 15254,
            fmt: "c",
            args: [
                /**1宝石*/
                sub_mod: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1宝石*/
            sub_mod: number
        ];
        recv: {
            /** 1宝石 */
            sub_mod: number;
            /** 战力值 */
            power: number;
        };
    };
    15255: {
        desc: "装备神炼";
        send: (number: 15255, fmt: "l", args: [goods_id: number]) => never;
        sendFmt: "l";
        sendArgs: [goods_id: number];
        recv: {
            code: number;
            goods_id: number;
            /** 新的神炼等级 */
            refine_lv: number;
        };
    };
    15256: {
        desc: "套装收集列表(已激活)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            clt_list: {
                suit_id: number;
                /** 当前已激活阶段 2,4,6,8 */
                cur_stage: number;
                cur_pos_list: {
                    /** 装备位置 */
                    equip_type: number;
                }[];
            }[];
            /** 穿着时装对应的套装id，0表示无 */
            suit_id: number;
        };
    };
    15257: {
        desc: "套装收集激活";
        send: (
            number: 15257,
            fmt: "cc",
            args: [suit_id: number, stage: number]
        ) => never;
        sendFmt: "cc";
        sendArgs: [suit_id: number, stage: number];
        recv: {
            code: number;
            suit_id: number;
            cur_stage: number;
            cur_pos_list: {
                /** 装备位置 */
                equip_type: number;
            }[];
        };
    };
    15258: {
        desc: "套装收集点亮";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            suit_id_list: {
                /** 激活的套装列表 */
                suit_id: number;
            }[];
            equip_type: number;
        };
    };
    15259: {
        desc: "套装收集穿戴时装";
        send: (
            number: 15259,
            fmt: "cc",
            args: [
                /**套装id*/
                suit_id: number,
                /**1:穿 0：脱*/
                is_wear: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**套装id*/
            suit_id: number,
            /**1:穿 0：脱*/
            is_wear: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 套装id */
            suit_id: number;
            /** 1:穿 0：脱 */
            is_wear: number;
        };
    };
    15260: {
        desc: "激活全身奖励";
        send: (
            number: 15260,
            fmt: "c",
            args: [
                /**类型 1：装备全身强化 3: 宝石（后续扩展）*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**类型 1：装备全身强化 3: 宝石（后续扩展）*/
            type: number
        ];
        recv: {
            errcode: number;
            type: number;
            whole_lv: number;
        };
    };
    15261: {
        desc: "全身奖励信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                type: number;
                whole_lv: number;
            }[];
        };
    };
}
