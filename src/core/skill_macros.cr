module OSRS::Labs::Core::Skills
  macro def_skill(name)
    class {{ name.id }} < Skill
      def name
        "{{ name.id }}"
      end
    end
  end

  macro def_skills(names)
    {% for name in names %}
      def_skill {{name}}
    {% end %}

    class SkillOverview
      getter :overall
      {% for name in names %}
        getter {{name.downcase}}
      {% end %}

      def initialize
        @overall = Overall.new
        {% for name in names %}
          @{{name.id.downcase}} = {{name.id}}.new
        {% end %}
      end

      def get(name)
        to_h[name]
      end

      def equals(other : SkillOverview)
        return false if !overall.equals(other.overall)
        {% for name in names %}
          return false if !{{name.id.downcase}}.equals(other.{{name.id.downcase}})
        {% end %}
        true
      end

      def to_a
        [
          {% for name in names %}
            @{{name.id.downcase}},
          {% end %}
        ]
      end

      def to_h
        {
          {% for name in names %}
            "{{name.id}}" => @{{name.id.downcase}},
          {% end %}
        }
      end

      def to_s(io)
        overall.to_s io
        io << "\n"
        to_a.each do |skill|
          skill.to_s io
          io << "\n"
        end
      end
    end
  end
end
