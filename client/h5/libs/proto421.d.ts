/** 藏宝图
 */
declare interface ProtoFmtInfo {
    42101: {
        desc: "获得背包所有藏宝图坐标";
        send: (number: 42101, fmt: any, args: [goods_list: any]) => never;
        sendFmt: any;
        sendArgs: [goods_list: any];
        recv: {
            map_lists: {
                /** 发布者玩家ID */
                role_id: number;
                /** 物品唯一ID */
                goods_id: number;
                /** 物品生成时间戳 */
                produce_time: number;
                /** 藏宝图类型 1普通 2精致 3神秘 */
                type: number;
                /** 场景ID */
                scene: number;
                /** 当藏宝图为普通或精致时坐标数为1个，当为神秘藏宝图时坐标数为4个，所有的默认第一个为宝藏地点， */
                pos_list: {
                    /** 第几个坐标 */
                    pos: number;
                    /** x坐标 */
                    x: number;
                    /** y坐标 */
                    y: number;
                    /** 发掘线索玩家ID */
                    clue: number;
                    /**  发掘线索玩家名字 */
                    name: string;
                }[];
            }[];
        };
    };
    42102: {
        desc: "使用地图发布信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 发布者玩家ID */
            role_id: number;
            /** 物品唯一ID */
            goods_id: number;
            /** 物品生成时间戳 */
            produce_time: number;
            /** 藏宝图类型 1普通 2精致 3神秘 */
            type: number;
            /** 场景ID */
            scene: number;
            /** 当藏宝图为普通或精致时坐标数为1个，当为神秘藏宝图时坐标数为4个，所有的默认第一个为宝藏地点， */
            pos_list: {
                /** 第几个坐标 */
                pos: number;
                /** x坐标 */
                x: number;
                /** y坐标 */
                y: number;
                /** 发掘线索玩家ID */
                clue: number;
                /**  发掘线索玩家名字 */
                name: string;
            }[];
        };
    };
    42103: {
        desc: "采集线索";
        send: (
            number: 42103,
            fmt: "ll",
            args: [
                /**物品唯一ID*/
                goods_id: number,
                /**发布者玩家ID*/
                push_id: number
            ]
        ) => never;
        sendFmt: "ll";
        sendArgs: [
            /**物品唯一ID*/
            goods_id: number,
            /**发布者玩家ID*/
            push_id: number
        ];
        recv: {
            /** 1成功 */
            errcode: number;
        };
    };
    42104: {
        desc: "成功使用地图";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 发布者玩家ID */
            role_id: number;
            /** 物品唯一ID */
            goods_id: number;
            /** 物品生成时间戳 */
            produce_time: number;
            /** 藏宝图类型 1普通 2精致 3神秘 */
            type: number;
            /** 场景ID */
            scene: number;
            /** 当藏宝图为普通或精致时坐标数为1个，当为神秘藏宝图时坐标数为4个，所有的默认第一个为宝藏地点， */
            pos_list: {
                /** 第几个坐标 */
                pos: number;
                /** x坐标 */
                x: number;
                /** y坐标 */
                y: number;
                /** 发掘线索玩家ID */
                clue: number;
                /**  发掘线索玩家名字 */
                name: string;
            }[];
        };
    };
    42106: {
        desc: "挖取宝藏";
        send: (
            number: 42106,
            fmt: "lc",
            args: [
                /**物品唯一ID*/
                goods_id: number,
                /**1开始挖 2结束挖*/
                status: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**物品唯一ID*/
            goods_id: number,
            /**1开始挖 2结束挖*/
            status: number
        ];
        recv: {
            /** 物品唯一ID */
            goods_id: number;
            /** 1开始挖 2结束挖 */
            status: number;
            /** 1成功 */
            errcode: number;
        };
    };
    42107: {
        desc: "随机邀请";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            errcode: number;
        };
    };
    42108: {
        desc: "同意进入藏宝图副本";
        send: (
            number: 42108,
            fmt: "i",
            args: [
                /**队伍id*/
                team_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**队伍id*/
            team_id: number
        ];
        recv: {
            /** 1成功 */
            errcode: number;
        };
    };
    42109: {
        desc: "队伍错误信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 队员名字 */
            name: string;
            errcode: number;
        };
    };
}
