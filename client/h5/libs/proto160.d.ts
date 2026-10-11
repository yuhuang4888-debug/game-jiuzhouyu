/** 坐骑信息
 */
declare interface ProtoFmtInfo {
    16000: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    16001: {
        desc: "场景广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 玩家ID */
            role_id: number;
            /** 0: 非骑乘 1: 骑乘 */
            is_ride: number;
            /** 玩家当前形象Id */
            figure_id: number;
            /** 玩家速度 */
            speed: number;
        };
    };
    16002: {
        desc: "坐骑类信息";
        send: (
            number: 16002,
            fmt: "c",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number
        ];
        recv: {
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 坐骑阶数 */
            stage: number;
            /** 当前星数 */
            star: number;
            /** 祝福值 */
            blessing: number;
            /** 幻化形象的等阶 */
            figure_stage: number;
            /** 坐骑战力 */
            combat: number;
            /** 祝福值清空时间 */
            etime: number;
            /** 是否自动购买 0：非自动，1：自动 */
            auto_buy: number;
            attr_list: {
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
        };
    };
    16003: {
        desc: "幻化坐骑";
        send: (
            number: 16003,
            fmt: "ccii",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**1:基础形象幻化 2:幻形形象幻化*/
                type: number,
                /**基础形象幻化:阶数 幻形形象幻化:幻形id*/
                args: number,
                /**基础形象幻化:0 幻形形象幻化:幻形颜色id  0*/
                color: number
            ]
        ) => never;
        sendFmt: "ccii";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**1:基础形象幻化 2:幻形形象幻化*/
            type: number,
            /**基础形象幻化:阶数 幻形形象幻化:幻形id*/
            args: number,
            /**基础形象幻化:0 幻形形象幻化:幻形颜色id  0*/
            color: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：伙伴 3: 翅膀 */
            type_id: number;
            /** 1:基础形象幻化 2:幻形形象幻化 */
            type: number;
            /** 基础形象幻化:阶数 幻形形象幻化:幻形id */
            args: number;
            /** 基础形象幻化:0 幻形形象幻化:幻形颜色id  0 */
            color: number;
        };
    };
    16004: {
        desc: "上下坐骑";
        send: (
            number: 16004,
            fmt: "cc",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**0: 下坐骑 1: 上坐骑*/
                type: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**0: 下坐骑 1: 上坐骑*/
            type: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 0: 下坐骑 1: 上坐骑 */
            type: number;
        };
    };
    16005: {
        desc: "升星（不包括坐骑伙伴）";
        send: (
            number: 16005,
            fmt: "c",
            args: [
                /**外形类型 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**外形类型 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物*/
            type_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物 */
            type_id: number;
            /** 阶数 */
            stage: number;
            /** 星数 */
            star: number;
            /** 祝福值 */
            blessing: number;
            /** 增加的祝福值 */
            blessing_plus: number;
            ratio_list: {
                /** 暴击倍率 */
                rate: number;
                /** 暴击数量 */
                rate_num: number;
            }[];
        };
    };
    16006: {
        desc: "幻形界面信息1";
        send: (
            number: 16006,
            fmt: "c",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 当前幻形形象id */
            illusion_id: number;
            /** 颜色id */
            color_id: number;
            /** 已激活的幻形形象列表 */
            figure_list: {
                /** 形象id */
                id: number;
                /** 阶数 */
                stage: number;
                /** 级数 */
                star: number;
                /** 到期时间 */
                time: number;
            }[];
        };
    };
    16007: {
        desc: "幻形形象详细信息";
        send: (
            number: 16007,
            fmt: "ci",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**形象id*/
                id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**形象id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 形象id */
            id: number;
            /** 阶数 */
            stage: number;
            /** 级数 */
            star: number;
            /** 经验值 */
            blessing: number;
            /** 战力 */
            combat: number;
            /** 升星战力 */
            star_combat: number;
            /** 到期时间 */
            time: number;
            attr_list: {
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
            color_list: {
                /** 颜色id */
                color_id: number;
                /** 等级 */
                color_lv: number;
            }[];
            /** 下一星的战力加成(未激活或者到最高星级时该值为0) */
            next_star_power: number;
        };
    };
    16008: {
        desc: "激活形象";
        send: (
            number: 16008,
            fmt: "ci",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**形象id*/
                id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**形象id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 形象id */
            id: number;
            /** 幻化战力 */
            combat: number;
        };
    };
    16009: {
        desc: "幻形升阶";
        send: (
            number: 16009,
            fmt: "cii",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**形象id*/
                id: number,
                /**道具卡id(坐骑，精灵玩家手动点击消耗某个物品才会用到，其他情况发0)*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "cii";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**形象id*/
            id: number,
            /**道具卡id(坐骑，精灵玩家手动点击消耗某个物品才会用到，其他情况发0)*/
            goods_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 形象id */
            id: number;
            /** 阶数 */
            stage: number;
            /** 祝福值 */
            blessing: number;
            /** 增加的祝福值 */
            blessing_plus: number;
            ratio_list: {
                /** 暴击倍率 */
                rate: number;
                /** 暴击数量 */
                rate_num: number;
            }[];
            /** 道具卡id(坐骑，精灵玩家手动点击消耗某个物品才会用到，其他情况发0) */
            goods_id: number;
        };
    };
    16010: {
        desc: "使用魔晶";
        send: (
            number: 16010,
            fmt: "ci",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**物品类型id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**物品类型id*/
            goods_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 物品类型id */
            goods_id: number;
        };
    };
    16011: {
        desc: "魔晶使用次数";
        send: (
            number: 16011,
            fmt: "c",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number
        ];
        recv: {
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 道具使用信息列表 */
            counter_list: {
                /** 物品id */
                goods_id: number;
                /** 使用次数 */
                times: number;
                /** 次数限制 */
                times_lim: number;
            }[];
        };
    };
    16012: {
        desc: "幻化过期消息通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 幻化形象id */
            id: number;
        };
    };
    16013: {
        desc: "技能属性战力显示";
        send: (
            number: 16013,
            fmt: "ci",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**技能id*/
                skill_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**技能id*/
            skill_id: number
        ];
        recv: {
            /** 技能id */
            skill_id: number;
            /** 技能战力 */
            power: number;
        };
    };
    16014: {
        desc: "打开坐骑、伙伴装备";
        send: (
            number: 16014,
            fmt: "c",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number
        ];
        recv: {
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 错误码 */
            errcode: number;
            /** 战力 */
            combat_power: number;
            /** 槽位列表 */
            pet_equip_list: {
                /** 槽位id */
                pos_id: number;
                /** 部位等级 */
                pos_lv: number;
                /** 阶数 */
                stage: number;
                /** 星数 */
                star: number;
                /** 部位经验 */
                pos_point: number;
                /** 物品唯一id */
                goods_id: number;
                /** 物品类型id */
                goods_type_id: number;
            }[];
        };
    };
    16015: {
        desc: "精灵装备镶嵌（装备）";
        send: (
            number: 16015,
            fmt: "ccl",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**槽位id*/
                pos_id: number,
                /**物品唯一id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "ccl";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**槽位id*/
            pos_id: number,
            /**物品唯一id*/
            goods_id: number
        ];
        recv: {
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 返回码 */
            code: number;
            /** 槽位id */
            pos_id: number;
            /** 穿上的精灵装备物品唯一id */
            new_goods_id: number;
            /** 脱下的精灵装备物品唯一id */
            old_goods_id: number;
            /** 穿上的精灵装备物品类型id */
            new_goods_type_id: number;
            /** 战力 */
            combat_power: number;
        };
    };
    16016: {
        desc: "精灵装备强化";
        send: (
            number: 16016,
            fmt: "clA",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**物品唯一id*/
                goods_id: number,
                /**消耗列表*/
                cost_list: any
            ]
        ) => never;
        sendFmt: "clA";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**物品唯一id*/
            goods_id: number,
            /**消耗列表*/
            cost_list: any
        ];
        recv: {
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 返回码 */
            code: number;
            /** 经验 */
            exp: number;
            /** 等级 */
            level: number;
            /** 物品唯一id */
            goods_id: number;
            /** 战力 */
            combat_power: number;
        };
    };
    16017: {
        desc: "精灵装备打磨";
        send: (
            number: 16017,
            fmt: "cll",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**物品唯一id*/
                goods_id: number,
                /**消耗品物品唯一id*/
                cost_goods_id: number
            ]
        ) => never;
        sendFmt: "cll";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**物品唯一id*/
            goods_id: number,
            /**消耗品物品唯一id*/
            cost_goods_id: number
        ];
        recv: {
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 返回码 */
            code: number;
            /** 阶数 */
            stage: number;
            /** 星数 */
            star: number;
            /** 物品唯一id */
            goods_id: number;
            /** 消耗品物品唯一id */
            cost_goods_id: number;
            /** 战力 */
            combat_power: number;
            /** 经验 */
            exp: number;
            /** 等级 */
            level: number;
        };
    };
    16018: {
        desc: "外形吞噬";
        send: (
            number: 16018,
            fmt: "cA",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                goods_list: any
            ]
        ) => never;
        sendFmt: "cA";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            goods_list: any
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 吞噬等级 */
            lv: number;
            /** 吞噬经验 */
            exp: number;
        };
    };
    16019: {
        desc: "吞噬信息";
        send: (
            number: 16019,
            fmt: "c",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 吞噬等级 */
            lv: number;
            /** 吞噬经验 */
            exp: number;
        };
    };
    16020: {
        desc: "幻形升级";
        send: (
            number: 16020,
            fmt: "ci",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**形象id*/
                id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**形象id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 形象id */
            id: number;
            /** 级数 */
            star: number;
        };
    };
    16021: {
        desc: "法阵广播(客户端自己倒计时广播)";
        send: (
            number: 16021,
            fmt: "c",
            args: [
                /**外形类型*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**外形类型*/
            type_id: number
        ];
        recv: {
            role_id: number;
        };
    };
    16022: {
        desc: "外形真实战力";
        send: (
            number: 16022,
            fmt: "cc",
            args: [
                /**外形类型*/
                type_id: number,
                /**幻型id*/
                id: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**外形类型*/
            type_id: number,
            /**幻型id*/
            id: number
        ];
        recv: {
            /** 外形类型 */
            type_id: number;
            /** 幻型id */
            id: number;
            /** 真实战力 */
            power: number;
            /** 当前的星级战力加成 */
            star_combat: number;
            /** 下一星的战力加成(未激活或者到最高星级时该值为0) */
            next_star_power: number;
        };
    };
    16023: {
        desc: "坐骑伙伴升星";
        send: (
            number: 16023,
            fmt: "ccc",
            args: [
                /**外形类型 1:坐骑 2：伙伴*/
                type_id: number,
                /**是否自动购买 0：非自动，1：自动*/
                auto_buy: number,
                /**是否消耗钻石 0：只消耗绑钻 1：允许消耗钻石*/
                gold_type: number
            ]
        ) => never;
        sendFmt: "ccc";
        sendArgs: [
            /**外形类型 1:坐骑 2：伙伴*/
            type_id: number,
            /**是否自动购买 0：非自动，1：自动*/
            auto_buy: number,
            /**是否消耗钻石 0：只消耗绑钻 1：允许消耗钻石*/
            gold_type: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：伙伴 */
            type_id: number;
            /** 阶数 */
            stage: number;
            /** 星数 */
            star: number;
            /** 祝福值 */
            blessing: number;
            /** 增加的祝福值 */
            blessing_plus: number;
            /** 祝福值清空时间 */
            etime: number;
            /** 是否自动购买 0：非自动，1：自动 */
            auto_buy: number;
            ratio_list: {
                /** 暴击倍率 */
                rate: number;
                /** 暴击数量 */
                rate_num: number;
            }[];
        };
    };
    16024: {
        desc: "改变自动购买状态";
        send: (
            number: 16024,
            fmt: "cc",
            args: [
                /**外形类型 1:坐骑 2：伙伴*/
                type_id: number,
                /**是否自动购买 0：非自动，1：自动*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**外形类型 1:坐骑 2：伙伴*/
            type_id: number,
            /**是否自动购买 0：非自动，1：自动*/
            auto_buy: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：伙伴 */
            type_id: number;
            /** 是否自动购买 0：非自动，1：自动 */
            auto_buy: number;
        };
    };
    16026: {
        desc: "使用染色剂";
        send: (
            number: 16026,
            fmt: "cci",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number,
                /**幻型id*/
                id: number,
                /**颜色id*/
                color_id: number
            ]
        ) => never;
        sendFmt: "cci";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number,
            /**幻型id*/
            id: number,
            /**颜色id*/
            color_id: number
        ];
        recv: {
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 幻型id */
            id: number;
            /** 颜色id */
            color_id: number;
            /** 返回码 */
            code: number;
        };
    };
    16027: {
        desc: "幻化升星预览";
        send: (
            number: 16027,
            fmt: "cc",
            args: [
                /**外形类型*/
                type_id: number,
                /**幻型id*/
                id: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**外形类型*/
            type_id: number,
            /**幻型id*/
            id: number
        ];
        recv: {
            /** 外形类型 */
            type_id: number;
            /** 幻型id */
            id: number;
            /** 当前的星级战力加成 */
            power: number;
            /** 下一星的战力加成 */
            next_star_power: number;
        };
    };
    16028: {
        desc: "坐骑类升级养成线面板信息";
        send: (
            number: 16028,
            fmt: "c",
            args: [
                /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑*/
            type_id: number
        ];
        recv: {
            /** 外形类型 1:坐骑 2：精灵 3: 翅膀 4:藏品 5：神兵 6：伙伴 7：飞骑 */
            type_id: number;
            /** 当前等级 */
            level: number;
            /** 当前祝福值 */
            cur_exp: number;
            /** 坐骑战力 */
            combat: number;
            attr_list: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
            /** 解锁技能列表 */
            skill_list: {
                /** 技能id */
                skill_id: number;
                /** 技能等级 */
                skill_level: number;
            }[];
        };
    };
    16029: {
        desc: "坐骑升级养成线操作";
        send: (
            number: 16029,
            fmt: "c",
            args: [
                /**外形类型 1:坐骑 2：伙伴 3: 翅膀  4:神器 5：圣器 6：精灵 7：宠物*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**外形类型 1:坐骑 2：伙伴 3: 翅膀  4:神器 5：圣器 6：精灵 7：宠物*/
            type_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：伙伴 3: 翅膀  4:神器 5：圣器 6：精灵 7：宠物 */
            type_id: number;
            /** 等级 */
            level: number;
            /** 经验值 */
            cur_exp: number;
            /** 增加的经验值 */
            add_exp: number;
            /** 坐骑战力 */
            combat: number;
            /** 解锁技能列表 */
            skill_list: {
                /** 技能id */
                skill_id: number;
                /** 技能等级 */
                skill_level: number;
            }[];
            ratio_list: {
                /** 暴击倍率 */
                rate: number;
                /** 暴击数量 */
                rate_num: number;
            }[];
        };
    };
    16030: {
        desc: "坐骑类升级养成线的技能升级";
        send: (
            number: 16030,
            fmt: "ci",
            args: [
                /**外形类型 1:坐骑 2：伙伴 3: 翅膀  4:神器 5：圣器 6：精灵 7：宠物*/
                type_id: number,
                /**需要升级的技能ID*/
                skill_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**外形类型 1:坐骑 2：伙伴 3: 翅膀  4:神器 5：圣器 6：精灵 7：宠物*/
            type_id: number,
            /**需要升级的技能ID*/
            skill_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 外形类型 1:坐骑 2：伙伴 3: 翅膀  4:神器 5：圣器 6：精灵 7：宠物 */
            type_id: number;
            /** 需要升级的技能ID */
            skill_id: number;
            /** 技能等级 */
            level: number;
        };
    };
}
