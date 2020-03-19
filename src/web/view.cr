require "ecr"

abstract class OSRS::Labs::Web::View
  macro partial(filename)
    ECR.embed {{filename}}, "__io__"
  end

  macro template(filename)
    def render_template(__io__)
      ECR.embed {{filename}}, "__io__"
    end
  end

  macro parent(filename)
    def render_parent(__io__)
      ECR.embed {{filename}}, "__io__"
    end
  end

  def render_parent(__io__)
    render_template __io__
  end

  def to_s(__io__)
    render_parent __io__
  end
end
