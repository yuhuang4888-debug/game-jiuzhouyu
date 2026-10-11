/** 成就
 */
declare interface ProtoFmtInfo {
    41001: {
        desc: "获取未领取成就的标签";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 成就id列表 */
            ids: {
                /** 成就id */
                achv_id: number;
            }[];
        };
    };
    41002: {
        desc: "获取成就列表";
        send: (
            number: 41002,
            fmt: "hc",
            args: [
                /**成就类型*/
                achv_type: number,
                /**分类标签*/
                label: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**成就类型*/
            achv_type: number,
            /**分类标签*/
            label: number
        ];
        recv: {
            /** 成就类型 */
            achv_type: number;
            /** 分类标签 */
            label: number;
            achv_list: {
                /** 成就Id */
                achv_id: number;
                /** 成就状态 1-未完成状态 0-未领取状态 2-已领取状态 3-已达成状态 */
                status: number;
                /** 当前数值 */
                cur_step: number;
                /** 是否显示进度 1-显示 0-不显示 */
                show_step: number;
            }[];
        };
    };
    41003: {
        desc: "更新成就进度";
        send: (
            number: 41003,
            fmt: "hh",
            args: [
                /**成就类型*/
                type: number,
                /**数量*/
                num: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**成就类型*/
            type: number,
            /**数量*/
            num: number
        ];
        recv: {
            /** 分类标签 */
            label: number;
            /** Id */
            achv_id: number;
            /** 状态 1-未完成状态 0-未领取状态 2-已领取状态 3-已达成状态 */
            status: number;
            /** 当前数值 */
            cur_step: number;
            /** 是否显示进度 1-显示 0-不显示 */
            show_step: number;
        };
    };
    41004: {
        desc: "领取成就";
        send: (
            number: 41004,
            fmt: "i",
            args: [
                /**成就id*/
                achv_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**成就id*/
            achv_id: number
        ];
        recv: {
            /** 1 成功 */
            code: number;
        };
    };
    41005: {
        desc: "推送有成就可领取注：成就变为可领取时自动主动推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 成就id */
            achv_id: number;
            /** 标签 */
            label: number;
        };
    };
    41006: {
        desc: "成就星级总览";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前星级 */
            cur_achv: number;
            /** 总星级 */
            total_achv: number;
            /** 各类型星级情况 */
            star_list: {
                /** 成就类型 */
                achv_type: number;
                /** 该类型总星级 */
                total_star: number;
                /** 该类型成就星级 */
                cur_star: number;
            }[];
        };
    };
}
