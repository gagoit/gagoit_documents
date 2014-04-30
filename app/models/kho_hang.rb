class KhoHang
  include Mongoid::Document

  field :vi_tri_name, type: String
  field :left, type: Integer
  field :top, type: Integer
  field :width, type: Integer
  field :height, type: Integer
  field :status, type: Integer, default: 1

  has_many :vi_tri_don_hangs

  STATUS ={1 => "ko_co_hang", 2 => "co_hang", 3 => "disable", 4 => "full"}

  INV_STATUS = STATUS.invert

  STATUS_COLORS ={1 => "green", 2 => "blue", 3 => "yellow", 4 => "red"}

  validates :vi_tri_name, length: {maximum: 10}

  scope :vitri, lambda { |name| where(vi_tri_name: name)  }

  def to_json
    {
      id: id,
      name: vi_tri_name,
      left: left,
      top: top,
      width: width,
      height: height,
      status: STATUS[self.status],
      color: STATUS_COLORS[self.status]
    }
  end

  def status_text
    STATUS[self.status]
  end

  def color
    STATUS_COLORS[self.status]
  end

  def self.get_vi_tri(name)
    vi_tri = self.vitri(name).first
    return {} if vi_tri.nil?
    vt_data = vi_tri.to_json

    vt_data[:donhangs] = []

    vi_tri.vi_tri_don_hangs.each do |e|
      dh = e.donhang.to_json
      dh[:so_luong] = e.so_luong
      dh[:user_import] = e.user.name
      dh[:import_date] = e.created_at
      dh[:vt_dh_id] = e.id

      vt_data[:donhangs] << dh.dup
    end

    vt_data
  end

  LABEL_LEFT = [
    "E3--4--22", "E2--4--22", "E1--4--22", "E0--4--22", "-",
    "D1--4--22", "D2--4--22", "D3--4--22", "D4--4--22", "-",
    "C4--5--22", "C3--5--22", "C2--5--22", "C1--5--22", "C0--5--22", "-",
    "B1--4--19", "B2--4--19", "B3--4--19", "B4--4--19", "-"]

  LABEL_RIGHT = [
    "F3--4--16", "F2--4--16", "F1--4--16", "F0--4--16", "-",
    "G1--4--16", "G2--4--16", "G3--4--16", "G4--4--16", "-",
    "H4--5--16", "H3--5--16", "H2--5--16", "H1--5--16", "H0--5--16", "-",
    "I1--4--16", "I2--4--16", "I3--4--16", "I4--4--16", "-",
    "J4--5--14", "J3--5--14", "J2--5--14", "J1--5--14", "J0--5--14", "-",
    "K1--4--16", "K2--4--16", "K3--4--16", "K4--4--16", "-"]

  LABEL_OTHER = [
    "A4--4--8", "A3--4--8", "A2--4--8", "A1--4--8",
    "A0--1--13", "-"]

  RACKS_NAME = ["A", "A0", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"]

  RACKS_NAME_LEFT = ["A0", "B", "C", "D", "E"]

  RACKS_NAME_RIGHT = ["A", "F", "G", "H", "I", "J", "K"]

  NAME_LOAI = [
    "B409", "B309", "B209", "B109", "B410", "B310", "B210", "B110",
    "B411", "B311", "B211", "B111", "B412", "B312", "B212", "B112",
    "B413", "B313", "B213", "B113", "B414", "B314", "B214", "B114",
    "B415", "B315", "B215", "B115", "B416", "B316", "B216", "B116",
    "B417", "B317", "B217", "B117",
    "E009", "E109", "E209", "E309", "E010", "E110", "E210", "E310",
    "F305", "F306",
    "F205", "F206",
    "F105", "F106",
    "F005", "F006",
    "G115", "G116",
    "G215", "G216", 
    "G315", "G316", 
    "G415", "G416",
    "H315", "H316", "H415", "H416",
    "H101", "H102", "H103", "H104", "H105", "H106", "H107", "H108",
    "H109", "H110", "H111", "H112", "H113", "H114", "H115", "H116",
    "H201", "H202", "H203", "H204", "H205", "H206", "H207", "H208",
    "H209", "H210", "H211", "H212", "H213", "H214", "H215", "H216",
    "H001", "H002", "H003", "H004", "H005", "H006", "H007", "H008",
    "H009", "H010", "H011", "H012", "H013", "H014", "H015", "H016",
    "I101", "I102", "I103", "I104", "I105", "I106", "I107", "I108",
    "I109", "I110", "I111", "I112", "I113", "I114", "I115", "I116",
    "I201", "I202", "I203", "I204", "I205", "I206", "I207", "I208",
    "I209", "I210", "I211", "I212", "I213", "I214", "I215", "I216",
    "I315", "I316", "I415", "I416"
  ]

  ##
  # dat ten cho 1 vi-tri
  ##
  def self.create_vi_tri_name(label, row, label_type)
    name = ""
    if (label_type == ("left"))
      name = label.split("--")[0]

    elsif (label_type == ("right"))
      name = label.split("--")[0]

    else
      name = label.split("--")[0]
    end

    if (name.index("A0") == 0)
      if (row < 10)
        return (name + "0" + row.to_s)
      end
      return (name + row.to_s)
    end

    if (row < 10)
      name += "0" + row.to_s
    else
      name += row.to_s
    end

    return name
  end

  def self.find_and_create_vi_tri(name, dx, dy, x, y)
    if vitri = self.where(vi_tri_name: name).first
      vitri
    else
      self.create(vi_tri_name: name, left: x, top: y, width: dx, height: dy)
    end
  end

  def self.create_vi_tris
    self.khoi_tao_thong_tin_khoang_ben_trai
    self.khoi_tao_thong_tin_khoang_ben_phai
    self.khoi_tao_thong_tin_khoang_other
  end

  ##
  #khoi tao ten cua cac khoang va thong tin cua no
  #khoang tu` (A->K)(1->39)
  ##
  def self.khoi_tao_thong_tin_khoang_ben_trai
    current_name_ABC = ""
    p_so_khoang_ABC = 0
    name_o = ""
    x = 500
    y = 50
    dx = 20
    dy = 15
    columns_of_ABC = 0
    rows_of_ABC = 0
    temp = []

    LABEL_LEFT.each_with_index do |label, column|
      # duong di
      if (label == ("-"))
        y += 20
        if (p_so_khoang_ABC > 0)
          #tru di so o bi loai o moi day
          if (current_name_ABC.index("B") == 0)
            p_so_khoang_ABC -= 36
          elsif (current_name_ABC.index("E") ==0)
            p_so_khoang_ABC -= 8
          end

          
        end
        p_so_khoang_ABC = 0
      else
        current_name_ABC = label.split("--")[0]
        current_name_ABC = current_name_ABC[0]

        # cac khoang
        x = 500
        temp = label.split("--")
        columns_of_ABC = temp[1].to_i
        rows_of_ABC = temp[2].to_i

        (1..rows_of_ABC).each do |row|
          if (row > 1)
            x -= dx
          end
          name_o = self.create_vi_tri_name(label, row, "left")
          
          v = self.find_and_create_vi_tri(name_o, dx, dy, x, y)
          
          p_so_khoang_ABC += 1
        end

        y += dy

      end
    end
  end

  def self.khoi_tao_thong_tin_khoang_ben_phai
    current_name_ABC = ""
    next_name_ABC = ""
    p_so_khoang_ABC = 0
    name_o = ""
    x = 570
    y = 50
    dx = 20
    dy = 15
    columns_of_ABC = 0
    rows_of_ABC = 0
    temp = []

    LABEL_RIGHT.each_with_index do |label, column|
      # duong di
      if (label == ("-"))
        y += 20
        if (p_so_khoang_ABC > 0)
          #tru di so o bi loai o moi day
          if (current_name_ABC.index("F") == 0)
            p_so_khoang_ABC = 16
          elsif (current_name_ABC.index("G") == 0)
            p_so_khoang_ABC -= 22
          elsif (current_name_ABC.index("H") == 0)
            p_so_khoang_ABC -= 52
          elsif (current_name_ABC.index("I") == 0)
            p_so_khoang_ABC -= 36
          elsif (current_name_ABC.index("J") == 0 || current_name_ABC.index("K") == 0)
            p_so_khoang_ABC = 0
          end

        end
        p_so_khoang_ABC = 0
      else
        current_name_ABC = label.split("--")[0]
        current_name_ABC = current_name_ABC[0]

        x = 570
        temp = label.split("--")
        columns_of_ABC = temp[1].to_i
        rows_of_ABC = temp[2].to_i

        (1..rows_of_ABC).each do |row|
          if (row > 1)
            x += dx
          end
          name_o = self.create_vi_tri_name(label, row, "right")

          v = self.find_and_create_vi_tri(name_o, dx, dy, x, y)
          
          p_so_khoang_ABC += 1
        end
        y += dy

      end
    end
  end

  def self.khoi_tao_thong_tin_khoang_other
    current_name_ABC = ""
    p_so_khoang_ABC = 0
    name_o = ""
    x = 150
    y = 450
    dx = 20
    dy = 15
    columns_of_ABC = 0
    rows_of_ABC = 0
    temp = []

    LABEL_OTHER.each_with_index do |label, column|
      # duong di
      if (label == ("-"))
        if (p_so_khoang_ABC > 0)
          #tru di so o bi loai o moi day
          
        end
        p_so_khoang_ABC = 0
      else
        current_name_ABC = label.split("--")[0]
        current_name_ABC = current_name_ABC[0]

        if (label.index("A0") == 0)
          temp = label.split("--")
          columns_of_ABC = temp[1].to_i
          rows_of_ABC = temp[2].to_i

          x = 150
          (1..rows_of_ABC).each do |j|
            if (j == 1)
              x = 150 + 3 * dx
              y = 450 - dy
            elsif (j <= 8)
              x = 150 + 4 * dx
              y = 450 - dy + dy * (j - 2)
            else
              x = 150 + 5 * dx + dx * (j - 9)
              y = 450 + dy * 7
            end

            name_o = self.create_vi_tri_name(label, j, "other")
            v = self.find_and_create_vi_tri(name_o, dx, dy, x, y)
            
            p_so_khoang_ABC += 1
          end

          x += dx

        else  # cac khoang
          y = 450
          temp = label.split("--")
          columns_of_ABC = temp[1].to_i
          rows_of_ABC = temp[2].to_i

          (1..rows_of_ABC).each do |row|
            if (row > 1)
              y += dy
            end
            name_o = self.create_vi_tri_name(label, row, "other")

            v = self.find_and_create_vi_tri(name_o, dx, dy, x, y)
            
            p_so_khoang_ABC += 1
          end
          x += dx
        end
      end
    end
  end

end
