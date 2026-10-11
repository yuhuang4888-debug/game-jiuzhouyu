/** 永恒碑谷
 */
declare interface ProtoFmtInfo {
    42400: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    42401: {
        desc: "碑谷列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 只发已解锁的章节 */
            list: {
                /** 章节id */
                chapter: number;
                /** 章节奖励领取状态 0: 未达成 1: 已达成 2: 已领取 */
                status: number;
                /** 只发有进度的数据 */
                stage_list: {
                    /** 阶段 */
                    stage: number;
                    /** 进度 */
                    progress: number;
                    /** 奖励状态 0: 未达成 1: 已达成 2: 已领取 */
                    status: number;
                    /**  附加信息 */
                    extra: string;
                }[];
            }[];
        };
    };
    42402: {
        desc: "碑谷信息";
        send: (
            number: 42402,
            fmt: "c",
            args: [
                /**章节id*/
                chapter: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**章节id*/
            chapter: number
        ];
        recv: {
            /** 章节id */
            chapter: number;
            /** 章节奖励领取状态 0: 未达成 1: 已达成 2: 已领取 */
            status: number;
            /** 只发有进度的数据 */
            stage_list: {
                /** 阶段 */
                stage: number;
                /** 进度 */
                progress: number;
                /** 奖励状态 0: 未达成 1: 已达成 2: 已领取 */
                status: number;
                /**  附加信息 */
                extra: string;
            }[];
        };
    };
    42403: {
        desc: "状态更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 章节id */
                chapter: number;
            }[];
        };
    };
    42404: {
        desc: "领取阶段奖励";
        send: (
            number: 42404,
            fmt: "cc",
            args: [
                /**章节id*/
                chapter: number,
                /**阶段*/
                stage: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**章节id*/
            chapter: number,
            /**阶段*/
            stage: number
        ];
        recv: {
            error_code: number;
            /** 章节id */
            chapter: number;
            /** 阶段 */
            stage: number;
        };
    };
    42405: {
        desc: "领取章节奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 章节id */
            chapter: number;
        };
    };
    42406: {
        desc: "任务进度变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 章节id */
            chapter: number;
            /** 阶段 */
            stage: number;
            /** 进度 */
            progress: number;
            /** 奖励状态 0: 未达成 1: 已达成 */
            status: number;
        };
    };
}
