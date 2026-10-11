/** 神殿觉醒
 */
declare interface ProtoFmtInfo {
    42900: {
        desc: "完成开启之路任务（点击了按钮）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    42901: {
        desc: "神殿列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 开启之路任务是否已完成（客户端发没发过42900） */
            task_complete: number;
            /** 只发已解锁的章节 */
            list: {
                /** 章节id */
                chapter: number;
                /** 章节奖励领取状态 1:进行中；2：可领取; 3:已领取 */
                status: number;
                /** 对应外形状态	1：穿戴中， 0未穿戴 */
                is_wear: number;
                /** 只发已解锁的子章节（页） */
                sub_list: {
                    /** 子章节id */
                    sub_chapter: number;
                    /** 状态 ：1已解锁  2已完成 */
                    sub_status: number;
                    /** 只发已解锁的数据 */
                    stage_list: {
                        /** 子章节阶段 */
                        stage: number;
                        /** 阶段状态 1:进行中；2：可领取；3已领取 */
                        status: number;
                        /** 进度值 */
                        process: number;
                    }[];
                }[];
            }[];
        };
    };
    42902: {
        desc: "神殿章节信息";
        send: (
            number: 42902,
            fmt: "h",
            args: [
                /**章节id*/
                chapter: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**章节id*/
            chapter: number
        ];
        recv: {
            /** 章节id */
            chapter: number;
            /** 章节奖励领取状态 1:进行中；2：可领取; 3:已领取 */
            status: number;
            /** 只发已解锁的子章节（页） */
            sub_list: {
                /** 子章节id */
                sub_chapter: number;
                /** 状态 ：1进行中；2已完成 */
                sub_status: number;
                /** 只发已解锁的数据 */
                stage_list: {
                    /** 子章节阶段 */
                    stage: number;
                    /** 阶段状态 1:进行中；2：可领取；3已领取 */
                    status: number;
                    /** 进度值 */
                    process: number;
                }[];
            }[];
        };
    };
    42903: {
        desc: "章节状态更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 章节id */
            chapter: number;
            /** 章节奖励领取状态 1:进行中；2：可领取; 3:已领取 */
            status: number;
        };
    };
    42904: {
        desc: "子章节（页）状态更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 章节id */
            chapter: number;
            /** 子章节id */
            sub_chapter: number;
            /** 子章节奖励领取状态 1:进行中；2：可领取; 3:已领取 */
            sub_status: number;
        };
    };
    42905: {
        desc: "子章节阶段任务变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 章节id */
            chapter: number;
            /** 子章节id */
            sub_chapter: number;
            /** 阶段任务 */
            stage: number;
            /** 任务进度 */
            process: number;
            /** 1:进行中；2：可领取；3已领取 */
            stage_status: number;
        };
    };
    42906: {
        desc: "领取章节奖励";
        send: (
            number: 42906,
            fmt: "h",
            args: [
                /**章节id*/
                chapter: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**章节id*/
            chapter: number
        ];
        recv: {
            error_code: number;
            /** 章节id */
            chapter: number;
        };
    };
    42907: {
        desc: "领取章节阶段奖励";
        send: (
            number: 42907,
            fmt: "hhh",
            args: [
                /**章节id*/
                chapter: number,
                /**子章节id*/
                sub_chapter: number,
                /**阶段任务*/
                stage: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**章节id*/
            chapter: number,
            /**子章节id*/
            sub_chapter: number,
            /**阶段任务*/
            stage: number
        ];
        recv: {
            error_code: number;
            /** 章节id */
            chapter: number;
            /** 子章节id */
            sub_chapter: number;
            /** 阶段任务 */
            stage: number;
        };
    };
    42908: {
        desc: "奖励的套装穿戴状态";
        send: (
            number: 42908,
            fmt: "hc",
            args: [
                /**章节ID*/
                chapter: number,
                /**1:穿 0：脱*/
                is_wear: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**章节ID*/
            chapter: number,
            /**1:穿 0：脱*/
            is_wear: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 章节ID */
            chapter: number;
            /** 1:穿 0：脱 */
            is_wear: number;
        };
    };
    42909: {
        desc: "前置任务是否完成";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否完成前置任务 1：完成 0： 未完成 */
            is_finish: number;
        };
    };
    42910: {
        desc: "过场动画场景切换";
        send: (
            number: 42910,
            fmt: "ciii",
            args: [
                /**1：进入场景。 2：回到主线场景*/
                is_enter: number,
                /**场景ID*/
                scene_id: number,
                x: number,
                y: number
            ]
        ) => never;
        sendFmt: "ciii";
        sendArgs: [
            /**1：进入场景。 2：回到主线场景*/
            is_enter: number,
            /**场景ID*/
            scene_id: number,
            x: number,
            y: number
        ];
        recv: null;
    };
}
