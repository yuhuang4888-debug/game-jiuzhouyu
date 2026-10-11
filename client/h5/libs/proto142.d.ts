/** 伙伴（新）
 */
declare interface ProtoFmtInfo {
    14200: {
        desc: "场景广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 外形类型 10 伙伴 */
            type_id: number;
            /** 玩家ID */
            role_id: number;
            /** 玩家当前形象Id */
            figure_id: number;
        };
    };
    14201: {
        desc: "伙伴信息涉及伙伴战力改动的协议会主动推一次";
        send: (number: 14201, fmt: "i", args: [companion_id: number]) => never;
        sendFmt: "i";
        sendArgs: [companion_id: number];
        recv: {
            sum_attr: {
                attr_id: number;
                attr_val: number;
            }[];
            companion_id: number;
            /** 阶 */
            stage: number;
            /** 星 */
            star: number;
            /** 是否激活 */
            is_active: number;
            /** 祝福值 */
            blessing: number;
            /** 使用培养丹数 */
            train_num: number;
            attr: {
                attr_id: number;
                attr_val: number;
            }[];
            /** 战力 */
            combat: number;
            /** 出站伙伴id */
            fight_id: number;
        };
    };
    14202: {
        desc: "伙伴列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 出战伙伴id */
            fight_id: number;
            sum_attr: {
                attr_id: number;
                attr_val: number;
            }[];
            companion_list: {
                companion_id: number;
                /** 阶 */
                stage: number;
                /** 星 */
                star: number;
                /** 是否激活 */
                is_active: number;
                /** 是否出战 */
                is_fight: number;
                /** 外形id */
                figure_id: number;
                /** 祝福值 */
                blessing: number;
                /** 使用培养丹数 */
                train_num: number;
                attr: {
                    attr_id: number;
                    attr_val: number;
                }[];
                /** 战力 */
                combat: number;
            }[];
        };
    };
    14203: {
        desc: "出战";
        send: (
            number: 14203,
            fmt: "i",
            args: [
                /**伙伴id*/
                companion_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**伙伴id*/
            companion_id: number
        ];
        recv: {
            code: number;
            /** 出战伙伴id */
            fight_id: number;
            /** 外形id */
            figure_id: number;
        };
    };
    14204: {
        desc: "激活";
        send: (
            number: 14204,
            fmt: "i",
            args: [
                /**伙伴id*/
                companion_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**伙伴id*/
            companion_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            companion_id: number;
            /** 添加战力 */
            combat: number;
        };
    };
    14205: {
        desc: "升级";
        send: (
            number: 14205,
            fmt: "i",
            args: [
                /**伙伴id*/
                companion_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**伙伴id*/
            companion_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 背饰id */
            companion_id: number;
            /** 阶 */
            stage: number;
            /** 星 */
            star: number;
            /** 祝福值 */
            blessing: number;
        };
    };
    14206: {
        desc: "培养";
        send: (
            number: 14206,
            fmt: "i",
            args: [
                /**伙伴id*/
                companion_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**伙伴id*/
            companion_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 伙伴id */
            companion_id: number;
        };
    };
}
