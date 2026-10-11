/** 天启装备信息
 */
declare interface ProtoFmtInfo {
    28600: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            res: number;
        };
    };
    28601: {
        desc: "穿戴装备";
        send: (
            number: 28601,
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
    28602: {
        desc: "卸下装备";
        send: (
            number: 28602,
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
    28603: {
        desc: "吞噬";
        send: (
            number: 28603,
            fmt: "cA",
            args: [
                /**部位*/
                pos: number,
                goods_list: any
            ]
        ) => never;
        sendFmt: "cA";
        sendArgs: [
            /**部位*/
            pos: number,
            goods_list: any
        ];
        recv: {
            /** 部位 */
            pos: number;
            /** 聚灵等级 */
            lv: number;
            /** 经验 */
            exp: number;
        };
    };
    28604: {
        desc: "升级";
        send: (
            number: 28604,
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
            /** 部位 */
            pos: number;
            /** 聚灵等级 */
            lv: number;
            /** 经验 */
            exp: number;
        };
    };
    28605: {
        desc: "技能升级";
        send: (
            number: 28605,
            fmt: "i",
            args: [
                /**技能id*/
                skill_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**技能id*/
            skill_id: number
        ];
        recv: {
            /** 技能id */
            skill_id: number;
            /** 技能等级 */
            lv: number;
        };
    };
    28606: {
        desc: "天启装备信息";
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
    28607: {
        desc: "改变形象";
        send: (
            number: 28607,
            fmt: "h",
            args: [
                /**形象id*/
                figure: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**形象id*/
            figure: number
        ];
        recv: {
            /** 最大形象id */
            max_figure_id: number;
            /** 当前形象id */
            current_figure_id: number;
        };
    };
    28608: {
        desc: "套装更改";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 套装信息 */
            suit: {
                /** 星数 */
                star: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    28609: {
        desc: "天启战力信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 总战力 */
            power: number;
        };
    };
}
