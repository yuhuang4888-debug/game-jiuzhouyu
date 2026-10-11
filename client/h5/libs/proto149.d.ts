/** 幻饰信息
 */
declare interface ProtoFmtInfo {
    14900: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code_int: number;
            /** 返回消息 */
            code_msg: string;
        };
    };
    14901: {
        desc: "穿戴幻饰";
        send: (
            number: 14901,
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
            /** 装备格子位置 */
            cell_pos: number;
        };
    };
    14902: {
        desc: "卸下幻饰";
        send: (
            number: 14902,
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
            /** 装备位置，失败为0 */
            cell: number;
        };
    };
    14903: {
        desc: "幻饰进阶";
        send: (
            number: 14903,
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
            /** 返回码  1:成功  0 装备位置参数错误 */
            res: number;
            /** 新装备物品Id */
            new_goods_id: number;
            /** 装备位置 */
            cell: number;
            /** 进阶等级 */
            stage: number;
        };
    };
    14904: {
        desc: "强化信息";
        send: (
            number: 14904,
            fmt: "c",
            args: [
                /**装备位置*/
                cell: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装备位置*/
            cell: number
        ];
        recv: {
            /** 返回码  1:成功  0 装备未强化过 */
            res: number;
            /** 装备位置 */
            cell: number;
            /** 强化等级 */
            level: number;
            /** 强化评分 */
            point: number;
        };
    };
    14905: {
        desc: "强化装备";
        send: (
            number: 14905,
            fmt: "cc",
            args: [
                /**装备位置*/
                cell: number,
                /**1: 单次强化 2: 一键强化*/
                type: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**装备位置*/
            cell: number,
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
            level_info: {
                /** 装备位置 */
                cell: number;
                /** 强化等级 */
                level: number;
                /** 强化评分 */
                point: number;
            }[];
        };
    };
    14906: {
        desc: "进阶属性预览";
        send: (
            number: 14906,
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
    14907: {
        desc: "分解属性预览";
        send: (
            number: 14907,
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
    14908: {
        desc: "返回已解锁部位";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 已解锁槽位列表 */
            cell_list: {
                /** 槽位 */
                cell: number;
            }[];
        };
    };
}
