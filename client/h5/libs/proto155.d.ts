/** 圣印功能
 */
declare interface ProtoFmtInfo {
    15500: {
        desc: "错误码注：所有的协议错误码都返回15500，只有成功了，才返回相应的协议";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /**  参数 */
            args: string;
        };
    };
    15501: {
        desc: "获取身上圣印装备15010协议类型18获取圣印背包物品15010协议类型17穿戴";
        send: (
            number: 15501,
            fmt: "l",
            args: [
                /**物品唯一id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**物品唯一id*/
            id: number
        ];
        recv: {
            /** 物品唯一id */
            id: number;
            /** 被卸下的物品唯一id */
            old_id: number;
        };
    };
    15502: {
        desc: "脱下";
        send: (
            number: 15502,
            fmt: "l",
            args: [
                /**物品唯一id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**物品唯一id*/
            id: number
        ];
        recv: {
            id: number;
        };
    };
    15503: {
        desc: "强化信息";
        send: (
            number: 15503,
            fmt: "c",
            args: [
                /**装备位置*/
                equip_pos: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备位置*/
            equip_pos: number
        ];
        recv: {
            /** 装备位置 */
            equip_pos: number;
            /** 强化等级 */
            stren: number;
            /** 经验 */
            exp: number;
        };
    };
    15504: {
        desc: "强化装备";
        send: (
            number: 15504,
            fmt: "c",
            args: [
                /**装备位置*/
                equip_pos: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备位置*/
            equip_pos: number
        ];
        recv: {
            /** 装备位置 */
            equip_pos: number;
            /** 强化等级 */
            stren: number;
            /** 暴击倍率 1表示没有产生暴击 */
            mul: number;
            /** 经验 */
            exp: number;
        };
    };
    15505: {
        desc: "圣魂信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            soul_list: {
                /** 圣魂配置id 可找到效果配置 */
                goods_id: number;
                /** 当前使用次数 效果数值等于单次数值*使用次数 */
                use_count: number;
            }[];
        };
    };
    15506: {
        desc: "使用圣魂";
        send: (
            number: 15506,
            fmt: "i",
            args: [
                /**物品类型id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**物品类型id*/
            goods_id: number
        ];
        recv: {
            goods_id: number;
            use_count: number;
        };
    };
    15507: {
        desc: "圣印属性汇总";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 属性信息 */
            attr: any;
        };
    };
    15550: {
        desc: "圣殿信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 图腾状态 0 还未刷新 1 已经刷新 2跨服组尚未初始化 */
            totem_alive: number;
            /** 结束时间 状态0对应下次刷新时间 1对应图腾消失时间 */
            end_time: number;
        };
    };
    15551: {
        desc: "我的圣殿次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 剩余次数 */
            left_count: number;
            /** 总次数 */
            total_count: number;
            /** 当前所需门票数 */
            need_ticket: number;
        };
    };
    15552: {
        desc: "我的精力值";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的精力值 */
            energy_value: number;
        };
    };
    15553: {
        desc: "逐出圣殿";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    15554: {
        desc: "进入圣殿";
        send: (number: 15554, fmt: "i", args: [mon_id: number]) => never;
        sendFmt: "i";
        sendArgs: [mon_id: number];
        recv: {
            mon_id: number;
        };
    };
    15555: {
        desc: "占领图腾";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 图腾id（怪物id） 0表示无占领 */
            totem_id: number;
        };
    };
    15556: {
        desc: "续时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的精力值 */
            energy_value: number;
        };
    };
    15557: {
        desc: "退出圣殿";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    15558: {
        desc: "图腾占领状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            totem_list: {
                /** 图腾怪物唯一id */
                id: number;
                /** 当前占领人数 */
                num: number;
            }[];
        };
    };
    15559: {
        desc: "远离图腾";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    15560: {
        desc: "掉落记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            drop_log: {
                time: number;
                /**  服务器名字 */
                s_name: string;
                /** 玩家id */
                role_id: number;
                /** 服id */
                server_id: number;
                name: string;
                /** 场景id */
                scene_id: number;
                boss_id: number;
                /** 物品类型id */
                goods_id: number;
                /** 装备评分 */
                rating: number;
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
}
