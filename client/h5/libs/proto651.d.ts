/** 龙语boss
 */
declare interface ProtoFmtInfo {
    65100: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    65101: {
        desc: "界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 剩余次数 */
            left_count: number;
            /** 总次数 */
            all_count: number;
            map_lists: {
                map_id: number;
                /** 人数 */
                role_num: number;
                mon_list: {
                    /** 怪物id */
                    mon_id: number;
                    /** 复活时间戳 */
                    reborn_time: number;
                }[];
            }[];
        };
    };
    65102: {
        desc: "进入地图";
        send: (
            number: 65102,
            fmt: "cic",
            args: [
                /**地图id*/
                map_id: number,
                /**怪物id*/
                mon_id: number,
                /**是否自动购买通行证  0 否  1 是*/
                auto: number
            ]
        ) => never;
        sendFmt: "cic";
        sendArgs: [
            /**地图id*/
            map_id: number,
            /**怪物id*/
            mon_id: number,
            /**是否自动购买通行证  0 否  1 是*/
            auto: number
        ];
        recv: {
            /** 地图id */
            map_id: number;
            /** 怪物id */
            mon_id: number;
        };
    };
    65103: {
        desc: "退出";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    65104: {
        desc: "vip购买次数";
        send: (
            number: 65104,
            fmt: "c",
            args: [
                /**购买次数*/
                count: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**购买次数*/
            count: number
        ];
        recv: {
            /** 剩余次数 */
            left_count: number;
            /** 总次数 */
            all_count: number;
        };
    };
    65105: {
        desc: "剩余时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 地图id */
            map_id: number;
            mon_list: {
                /** 怪物id */
                mon_id: number;
                /** 复活时间戳 */
                reborn_time: number;
            }[];
            /** 人数 */
            role_num: number;
            /** 离开的时间戳 */
            time: number;
        };
    };
    65106: {
        desc: "掉落记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            drop_log: {
                time: number;
                server_id: number;
                server_num: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                name: string;
                /** bossid */
                boss_id: number;
                /** 物品类型id */
                goods_id: number;
                /** 数量 */
                num: number;
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
                /** 是否置顶 */
                is_top: number;
            }[];
        };
    };
    65107: {
        desc: "剩余时间";
        send: (
            number: 65107,
            fmt: "cc",
            args: [map_id: number, auto: number]
        ) => never;
        sendFmt: "cc";
        sendArgs: [map_id: number, auto: number];
        recv: {
            left_count: number;
            all_count: number;
            left_time: number;
        };
    };
}
