/** 战甲
 */
declare interface ProtoFmtInfo {
    14401: {
        desc: "获取玩家战甲信息";
        send: (
            number: 14401,
            fmt: "cc",
            args: [
                /**战甲阶数 0 全部*/
                stage: number,
                /**战甲类型 0 全部 1 启源 2 圣遗*/
                type: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**战甲阶数 0 全部*/
            stage: number,
            /**战甲类型 0 全部 1 启源 2 圣遗*/
            type: number
        ];
        recv: {
            stage_list: {
                /** 战甲阶数 */
                stage: number;
                type_list: {
                    /** 战甲类型 1 启源 2 圣遗 */
                    type: number;
                    /** 状态 0 未激活 1 已激活 */
                    status: number;
                    pos_list: {
                        /** 装备部位物品id */
                        gtype_id: number;
                        /** 战甲装备部位 */
                        pos: number;
                        /** 状态 0 未打造 1 已打造 */
                        status: number;
                    }[];
                }[];
            }[];
        };
    };
    14402: {
        desc: "战甲打造";
        send: (
            number: 14402,
            fmt: "ccc",
            args: [
                /**战甲阶数*/
                stage: number,
                /**战甲类型 1 启源 2 圣遗*/
                type: number,
                /**战甲装备部位*/
                pos: number
            ]
        ) => never;
        sendFmt: "ccc";
        sendArgs: [
            /**战甲阶数*/
            stage: number,
            /**战甲类型 1 启源 2 圣遗*/
            type: number,
            /**战甲装备部位*/
            pos: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            stage_list: {
                /** 战甲阶数 */
                stage: number;
                type_list: {
                    /** 战甲类型 1 启源 2 圣遗 */
                    type: number;
                    /** 状态 0 未激活 1 已激活 */
                    status: number;
                    pos_list: {
                        /** 装备部位物品id */
                        gtype_id: number;
                        /** 战甲装备部位 */
                        pos: number;
                        /** 状态 0 未打造 1 已打造 */
                        status: number;
                    }[];
                }[];
            }[];
        };
    };
}
