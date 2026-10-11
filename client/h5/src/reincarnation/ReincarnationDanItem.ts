import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { TaskModel } from "../commonModel/TaskModel";
import { ErlangParser } from "../util/ErlangParser";

export class ReincarnationDanItem extends BaseItemRenderer {

    WIDTH = 204;
    HEIGT = 168;

    public constructor() {
        super();
        this.base_file = "reincarnation";
        this.layout_file = "ReincarnationDanItem";

        this.load_callback = () => {

            this.LoadSuccess();
        }
        this.Load();

    }

    private LoadSuccess() {
    }

    public DeleteMe() {
        super.DeleteMe();
    }


    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data;
            let conf = TaskModel.GetInstance().GetTaskCfg(data.task_id);
            let content = ErlangParser.GetInstance().parse(conf.content);
            this.descLab.text = content[0][0][8];
            this.nameLab.text = conf.name;
        }
    }



    nameLab: Laya.Label
    descLab: Laya.Label
    stateImg: Laya.Image
    public GetComponents() {
        [
            this.nameLab,
            this.descLab,
            this.stateImg,
        ]
            = this.GetChildrenByNames([

                "nameLab",
                "descLab",
                "stateImg",
            ])
    }
}
window["ReincarnationDanItem"] = ReincarnationDanItem