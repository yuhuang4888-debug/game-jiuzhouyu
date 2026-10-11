/** 神器信息
 */
declare interface ProtoFmtInfo {
    17100: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    17102: {
        desc: "神器激活信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            id_list: {
                /** 神器Id */
                id: number;
            }[];
            points_list: {
                /** 积分id */
                type_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    17103: {
        desc: "神器详细信息";
        send: (
            number: 17103,
            fmt: "i",
            args: [
                /**神器Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**神器Id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 神器Id */
            id: number;
            /** 等级 */
            lv: number;
            /** 战力 */
            combat: number;
            percent_list: {
                /** 属性id */
                attr_id: number;
                /** 百分比 */
                percent: number;
            }[];
        };
    };
    17104: {
        desc: "神器激活";
        send: (
            number: 17104,
            fmt: "i",
            args: [
                /**神器Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**神器Id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 神器Id */
            id: number;
        };
    };
    17105: {
        desc: "神器强化升级";
        send: (
            number: 17105,
            fmt: "i",
            args: [
                /**神器Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**神器Id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 神器Id */
            id: number;
            /** 等级 */
            lv: number;
            /** 战力 */
            combat: number;
        };
    };
    17106: {
        desc: "神器附灵";
        send: (
            number: 17106,
            fmt: "i",
            args: [
                /**神器Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**神器Id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 神器Id */
            id: number;
            percent_list: {
                /** 属性id */
                attr_id: number;
                /** 百分比 */
                percent: number;
            }[];
            /** 战力 */
            combat: number;
        };
    };
}
